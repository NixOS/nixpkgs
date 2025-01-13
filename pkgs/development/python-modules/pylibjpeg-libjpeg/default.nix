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
}:

buildPythonPackage rec {
  pname = "pylibjpeg-libjpeg";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    tag = "v${version}";
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

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = false; # tests try to import 'libjpeg.data', which errors

  pythonImportsCheck = [ "libjpeg" ];

  meta = with lib; {
    description = "JPEG, JPEG-LS and JPEG XT plugin for pylibjpeg";
    homepage = "https://github.com/pydicom/pylibjpeg-libjpeg";
    changelog = "https://github.com/pydicom/pylibjpeg-libjpeg/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
