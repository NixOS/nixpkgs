{
  lib,
  buildPythonPackage,
  cybox,
  distutils,
  fetchFromGitHub,
  lxml,
  mixbox,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "maec";
  version = "4.1.0.17";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MAECProject";
    repo = "python-maec";
    rev = "refs/tags/v${version}";
    hash = "sha256-I2Ov2AQiC9D8ivHqn7owcTsNS7Kw+CWVyijK3VO52Og=";
  };

  build-system = [
    distutils
    setuptools
  ];

  dependencies = [
    cybox
    lxml
    mixbox
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "maec" ];

  meta = {
    description = "Library for parsing, manipulating, and generating MAEC content";
    homepage = "https://github.com/MAECProject/python-maec/";
    changelog = "https://github.com/MAECProject/python-maec/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
