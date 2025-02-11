{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  cython,
  poetry-core,
  setuptools,
  numpy,
  pydicom,
  pylibjpeg-data,
  pylibjpeg,
}:

let
  self = buildPythonPackage {
    pname = "pylibjpeg-libjpeg";
    version = "2.3.0";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "pydicom";
      repo = "pylibjpeg-libjpeg";
      tag = "v${self.version}";
      hash = "sha256-xqSA1cutTsH9k4l9CW96n/CURzkAyDi3PZylZeedVjA=";
      fetchSubmodules = true;
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'poetry-core >=1.8,<2' 'poetry-core'
    '';

    build-system = [
      cython
      poetry-core
      setuptools
    ];

    dependencies = [ numpy ];

    nativeCheckInputs = [
      pydicom
      pylibjpeg-data
      pylibjpeg
      pytestCheckHook
    ];

    doCheck = false; # circular test dependency with `pylibjpeg` and `pydicom`

    passthru.tests.check = self.overridePythonAttrs (_: {
      doCheck = true;
    });

    pythonImportsCheck = [ "libjpeg" ];

    meta = {
      description = "JPEG, JPEG-LS and JPEG XT plugin for pylibjpeg";
      homepage = "https://github.com/pydicom/pylibjpeg-libjpeg";
      changelog = "https://github.com/pydicom/pylibjpeg-libjpeg/releases/tag/v${self.version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ bcdarwin ];
    };
  };
in
self
