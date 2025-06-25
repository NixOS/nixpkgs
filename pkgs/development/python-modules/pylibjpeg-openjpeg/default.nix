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
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pylibjpeg-openjpeg";
    tag = "v${version}";
    hash = "sha256-T38Ur5NLF9iPTrDwT3GYgI6621A90zWP/leUxSqA70w=";
  };

  # don't use vendored openjpeg submodule:
  # (note build writes into openjpeg source dir, so we have to make it writable)
  postPatch = ''
    rmdir lib/openjpeg
    cp -r ${openjpeg.src} lib/openjpeg
    chmod +rwX -R lib/openjpeg

    substituteInPlace pyproject.toml --replace-fail "poetry-core >=1.8,<2" "poetry-core"
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
    changelog = "https://github.com/pydicom/pylibjpeg-openjpeg/releases/tag/v${version}";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ bcdarwin ];
    # darwin: numerous test failures, test dependency pydicom is marked as unsupported
    broken = stdenv.hostPlatform.isDarwin;
  };
}
