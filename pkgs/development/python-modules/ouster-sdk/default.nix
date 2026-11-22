{
  lib,
  stdenv,
  buildPackages,
  python,
  makePythonPath,
  buildPythonPackage,
  ouster-sdk,
  setuptools,
  nanobind,
  numpy,
  typing-extensions,
  click,
  flask,
  laspy,
  more-itertools,
  packaging,
  pillow,
  prettytable,
  psutil,
  requests,
  rosbags,
  threadpoolctl,
  zeroconf,
  pytestCheckHook,
  pytest-asyncio,
  testers,
}:

let
  stubgenPython =
    dependencies:
    buildPackages.writeShellScript "ouster-sdk-stubgen-python" ''
      unset _PYTHON_HOST_PLATFORM _PYTHON_SYSCONFIGDATA_NAME \
        NIX_PYTHONPATH NIX_PYTHONPREFIX NIX_PYTHONEXECUTABLE
      export PYTHONPATH="${makePythonPath dependencies}"
      exec ${stdenv.hostPlatform.emulator buildPackages} ${python.interpreter} "$@"
    '';
in
buildPythonPackage (finalAttrs: {
  inherit (ouster-sdk) pname version src;
  pyproject = true;

  # The SDK monkey-patches rosbags' private MCAP reader and connection types.
  # Use native MCAP support and the current writer API so we can share nixpkgs'
  # rosbags; a private runtime version causes collisions in Python environments.
  patches = [
    ./nix-compat.patch
    ./rosbags-compat.patch
  ];

  postPatch = ''
    cd python
  '';

  dontUseCmakeConfigure = true;

  inherit (ouster-sdk) nativeBuildInputs;

  buildInputs = ouster-sdk.propagatedBuildInputs;

  build-system = [
    setuptools
    nanobind
    numpy
    typing-extensions
  ];

  dependencies = [
    click
    flask
    laspy
    more-itertools
    numpy
    packaging
    pillow
    prettytable
    psutil
    requests
    rosbags
    setuptools
    threadpoolctl
    zeroconf
  ];

  pythonRelaxDeps = [
    "click"
    "flask"
    "prettytable"
    "psutil"
    "rosbags"
  ];

  # These are used to build bindings and run tests, respectively.
  pythonRemoveDeps = [
    "nanobind"
    "pytest-asyncio"
  ];

  env = {
    VCPKG_MANIFEST_MODE = "OFF";
    OUSTER_SDK_CMAKE_ARGS = lib.cmakeFeature "FLATBUFFERS_FLATC_EXECUTABLE" (
      lib.getExe buildPackages.flatbuffers
    );
  };

  # Build SDK and bindings together: Darwin needs metadata holders in one binary.
  # Build requirements are supplied by Nix rather than upstream's pip pins.
  pypaBuildFlags = [ "--skip-dependency-check" ];

  preBuild = ''
    export OUSTER_SDK_BUILD_JOBS="$NIX_BUILD_CORES"
  ''
  + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    # Configure with build Python and target headers.
    ousterCmakeFlags=()
    concatTo ousterCmakeFlags cmakeFlags cmakeFlagsArray
    export OUSTER_SDK_CMAKE_ARGS="$OUSTER_SDK_CMAKE_ARGS ''${ousterCmakeFlags[*]} \
      -DPython_INCLUDE_DIR=${python}/include/${python.libPrefix} \
      -DNB_Python_EXECUTABLE=${stubgenPython finalAttrs.passthru.dependencies}"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "ouster.sdk"
    "ouster.cli.core"
  ];

  passthru = {
    # The version and source hash are shared with the C++ package.
    inherit (ouster-sdk) updateScript;
    tests = lib.optionalAttrs (stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = removeAttrs ouster-sdk.meta [ "name" ] // {
    description = "Python SDK and command-line tools for Ouster lidar sensors";
    mainProgram = "ouster-cli";
  };
})
