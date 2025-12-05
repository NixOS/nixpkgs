{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  ninja,
  scikit-build-core,
  pybind11,
  boost,
  eigen,
  python,
  catch2,
  numpy,
  pytest,
  makeSetupHook,
}:
let
  setupHook = makeSetupHook {
    name = "pybind11-setup-hook";
    substitutions = {
      out = placeholder "out";
      pythonInterpreter = python.pythonOnBuildForHost.interpreter;
      pythonIncludeDir = "${python}/include/${python.libPrefix}";
      pythonSitePackages = "${python}/${python.sitePackages}";
    };
  } ./setup-hook.sh;
in
buildPythonPackage rec {
  pname = "pybind11";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    tag = "v${version}";
    hash = "sha256-ZiwNGsE1FOkhnWv/1ib1akhQ4FZvrXRCDnnBZoPp6r4=";
  };

  build-system = [
    cmake
    ninja
    pybind11.passthru.scikit-build-core-no-tests
  ];

  buildInputs = [
    # Used only for building tests - something we do even when cross
    # compiling.
    catch2
    boost
    eigen
  ];

  propagatedNativeBuildInputs = [ setupHook ];

  nativeCheckInputs = [
    numpy
    pytest
  ];

  pypaBuildFlags = [
    # Keep the build directory around to run the tests.
    "-Cbuild-dir=build"
  ];

  cmakeFlags = [
    # Always build tests, because even when cross compiling building the tests
    # is another confirmation that everything is OK.
    (lib.cmakeBool "BUILD_TESTING" true)

    # Override the `PYBIND11_NOPYTHON = true` in `pyproject.toml`. This
    # is required to build the tests.
    (lib.cmakeBool "PYBIND11_NOPYTHON" false)
  ];

  dontUseCmakeConfigure = true;

  ninjaFlags = [
    "-C"
    "build"
  ];

  checkTarget = "check";

  checkPhase = "ninjaCheckPhase";

  # Make the headers and CMake/pkg-config files inside the wheel
  # discoverable. This simulates the effect of the `pybind11[global]`
  # installation but works better for our build.
  postInstall = ''
    ln -s $out/${python.sitePackages}/pybind11/{include,share} $out/
  '';

  passthru = {
    # scikit-build-core's tests depend upon pybind11, and hence introduce
    # infinite recursion. To avoid this, we define here a scikit-build-core
    # derivation that doesn't depend on pybind11, and use it for pybind11's
    # build-system.
    scikit-build-core-no-tests = scikit-build-core.overridePythonAttrs {
      doCheck = false;
    };
  };

  hardeningDisable = lib.optional stdenv.hostPlatform.isMusl "fortify";

  meta = {
    homepage = "https://github.com/pybind/pybind11";
    changelog = "https://github.com/pybind/pybind11/blob/${src.rev}/docs/changelog.rst";
    description = "Seamless operability between C++11 and Python";
    mainProgram = "pybind11-config";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      yuriaisaka
      dotlambda
    ];
  };
}
