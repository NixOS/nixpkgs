{
  lib,
  stdenv,
  buildPackages,
  python,
  makePythonPath,
  buildPythonPackage,
  fetchPypi,
  ouster-sdk,
  cmake,
  pkg-config,
  setuptools,
  wheel,
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
  sdk = ouster-sdk;
  stubgenPython =
    dependencies:
    buildPackages.writeShellScript "ouster-sdk-stubgen-python" ''
      unset _PYTHON_HOST_PLATFORM _PYTHON_SYSCONFIGDATA_NAME \
        NIX_PYTHONPATH NIX_PYTHONPREFIX NIX_PYTHONEXECUTABLE
      export PYTHONPATH="${makePythonPath dependencies}"
      exec ${stdenv.hostPlatform.emulator buildPackages} ${python.interpreter} "$@"
    '';
  # Ouster replaces nb_func.cpp with a modified copy of nanobind 2.9.2 internals.
  nanobindForOuster = nanobind.overridePythonAttrs (oldAttrs: {
    version = "2.9.2";
    src = fetchPypi {
      pname = "nanobind";
      version = "2.9.2";
      hash = "sha256-52CEct6Z03V1mBTKs+LJSro/nsgOYs/vjO1JXKXCfW4=";
    };
    meta = oldAttrs.meta // {
      changelog = "https://github.com/wjakob/nanobind/blob/v2.9.2/docs/changelog.rst";
    };
  });
in
buildPythonPackage (finalAttrs: {
  pname = "ouster-sdk";
  inherit (sdk) version src;
  pyproject = true;

  patches = [
    # Use declared dependencies and omit the removed simple-viz entry point.
    ./nix-build.patch
    # Prebuilt bindings need only the SDK's shared component.
    ./shared-sdk.patch
    # Click 8.4 suggests command names; Ouster stores IoType keys in commands.
    ./click-compat.patch
    # The SDK monkey-patches rosbags' private MCAP reader and connection types.
    # Use native MCAP support and the current writer API so we can share nixpkgs'
    # rosbags; a private runtime version causes collisions in Python environments.
    ./rosbags-compat.patch
  ];

  postPatch = ''
    cd python
  ''
  + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    # Stub generation imports target bindings; configuration uses build Python.
    substituteInPlace CMakeLists.txt --replace-fail \
      'file(TO_CMAKE_PATH ''${Python_EXECUTABLE} NB_Python_EXECUTABLE)' \
      'set(NB_Python_EXECUTABLE "${stubgenPython finalAttrs.passthru.dependencies}")'
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ sdk ];

  build-system = [
    setuptools
    wheel
    nanobindForOuster
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
  }
  # Darwin needs metadata holders in the same binary for dynamic_cast.
  // lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
    OUSTER_SDK_PREBUILT_DIR = "${lib.getDev sdk}";
  };

  preBuild = ''
    export OUSTER_SDK_BUILD_JOBS="$NIX_BUILD_CORES"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "ouster.sdk"
    "ouster.sdk.core"
    "ouster.sdk.sensor"
    "ouster.sdk.pcap"
    "ouster.sdk.osf"
    "ouster.sdk.viz"
    "ouster.sdk.mapping"
    "ouster.sdk.bag"
    "ouster.cli.core"
  ];

  passthru = {
    # The version and source hash are shared with the C++ package.
    inherit (sdk) updateScript;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "ouster-cli --version";
    };
  };

  meta = {
    inherit (sdk.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = "Python SDK and command-line tools for Ouster lidar sensors";
    mainProgram = "ouster-cli";
  };
})
