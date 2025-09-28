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
  libjpeg-tools,
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
      hash = "sha256-P01pofPLTOa5ynsCkLnxiMzVfCg4tbT+/CcpPTeSViw=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'poetry-core >=1.8,<2' 'poetry-core'
      rmdir lib/libjpeg
      cp -r ${libjpeg-tools.src} lib/libjpeg
      chmod u+w lib/libjpeg
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
