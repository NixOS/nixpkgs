{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
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
  pytestCheckHook,
  libxcrypt,
  makeSetupHook,
}:
let
  setupHook = makeSetupHook {
    name = "pybind11-setup-hook";
    substitutions = {
      out = placeholder "out";
      pythonInterpreter = python.pythonOnBuildForHost.interpreter;
      pythonIncludeDir = "${python}/include/python${python.pythonVersion}";
      pythonSitePackages = "${python}/${python.sitePackages}";
    };
  } ./setup-hook.sh;
in
buildPythonPackage rec {
  pname = "pybind11";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    tag = "v${version}";
    hash = "sha256-uyeBTZL38kXIoNxZBWcMRx046+tVJ4ZmCOwGz+D2XJA=";
  };

  build-system = [
    cmake
    ninja
    pybind11.passthru.scikit-build-core-no-tests
  ];

  buildInputs =
    [
      # Used only for building tests - something we do even when cross
      # compiling.
      catch2
      boost
      eigen
    ]
    ++ lib.optionals (pythonOlder "3.9") [
      libxcrypt
    ];
  propagatedNativeBuildInputs = [ setupHook ];

  dontUseCmakeBuildDir = true;

  env = {
    SKBUILD_CMAKE_ARGS = lib.strings.concatStringsSep ";" [
      # Always build tests, because even when cross compiling building the tests
      # is another confirmation that everything is OK.
      (lib.cmakeBool "BUILD_TESTING" true)
      # From some reason this is needed for tests.
      (lib.cmakeBool "PYBIND11_NOPYTHON" false)
    ];
  };

  postBuild = ''
    # build tests
    make -j $NIX_BUILD_CORES
  '';

  postInstall = ''
    make install
    # Symlink the CMake-installed headers to the location expected by setuptools
    mkdir -p $out/include/${python.libPrefix}
    ln -sf $out/include/pybind11 $out/include/${python.libPrefix}/pybind11
  '';

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # require dependencies not available in nixpkgs
    "tests/test_embed/test_trampoline.py"
    "tests/test_embed/test_interpreter.py"
    # numpy changed __repr__ output of numpy dtypes
    "tests/test_numpy_dtypes.py"
    # no need to test internal packaging
    "tests/extra_python_package/test_files.py"
    # tests that try to parse setuptools stdout
    "tests/extra_setuptools/test_setuphelper.py"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # expects KeyError, gets RuntimeError
    # https://github.com/pybind/pybind11/issues/4243
    "test_cross_module_exception_translator"
  ];
  passthru = {
    # scikit-build-core's tests depend upon pybind11, and hence introduce
    # infinite recursion. To avoid this, we define here a scikit-build-core
    # derivation that doesn't depend on pybind11, and use it for pybind11's
    # build-system.
    scikit-build-core-no-tests = scikit-build-core.overridePythonAttrs (old: {
      doInstallCheck = false;
      nativeCheckInputs = [ ];
    });
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
