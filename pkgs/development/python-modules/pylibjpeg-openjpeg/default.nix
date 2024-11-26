{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cmake,
  cython,
  poetry-core,
  setuptools,
  numpy,
  openjpeg,
  pytestCheckHook,
  pydicom,
  pylibjpeg,
  pylibjpeg-data,
}:

buildPythonPackage rec {
  pname = "pylibjpeg-openjpeg";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pylibjpeg-openjpeg";
    rev = "refs/tags/v${version}";
    hash = "sha256-cCDnARElNn+uY+HQ39OnGJRz2vTz0I8s0Oe+qGvqM1o=";
  };

  # don't use vendored openjpeg submodule:
  # (note build writes into openjpeg source dir, so we have to make it writable)
  postPatch = ''
    rmdir lib/openjpeg
    cp -r ${openjpeg.src} lib/openjpeg
    chmod +rwX -R lib/openjpeg
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    cmake
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    pydicom
    pylibjpeg-data
    pylibjpeg
  ];
  disabledTestPaths = [
    # ignore a few Python test files (e.g. performance tests) in openjpeg itself:
    "lib/openjpeg"
  ];

  pytestFlagsArray = [ "openjpeg/tests" ];

  pythonImportsCheck = [ "openjpeg" ];

  meta = {
    description = "A J2K and JP2 plugin for pylibjpeg";
    homepage = "https://github.com/pydicom/pylibjpeg-openjpeg";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ bcdarwin ];
    # x86-linux: test_encode.py::TestEncodeBuffer failures
    # darwin: numerous test failures, seemingly due to issues setting up test data
    broken =
      (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) || stdenv.hostPlatform.isDarwin;
  };
}
