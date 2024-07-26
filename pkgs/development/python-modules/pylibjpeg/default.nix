{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  flit-core,
  setuptools,
  numpy,
  pydicom,
  pylibjpeg-data,
  pylibjpeg-libjpeg,
}:

buildPythonPackage rec {
  pname = "pylibjpeg";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pylibjpeg";
    rev = "refs/tags/v${version}";
    hash = "sha256-qGtrphsBBVieGS/8rdymbsjLMU/QEd7zFNAANN8bD+k=";
  };

  build-system = [ flit-core ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    pydicom
    pylibjpeg-data
    pylibjpeg-libjpeg
  ];

  pythonImportsCheck = [ "pylibjpeg" ];

  meta = with lib; {
    description = "Python framework for decoding JPEG images, with a focus on supporting Pydicom";
    homepage = "https://github.com/pydicom/pylibjpeg";
    changelog = "https://github.com/pydicom/pylibjpeg/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
