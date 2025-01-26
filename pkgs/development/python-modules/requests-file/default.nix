{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-file";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dashea";
    repo = "requests-file";
    tag = version;
    hash = "sha256-JtdtE44yiw2mLMZ0bJv0QiGWb7f8ywPLF7+BUufh/g4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requests_file" ];

  meta = with lib; {
    description = "Transport adapter for fetching file:// URLs with the requests python library";
    homepage = "https://github.com/dashea/requests-file";
    changelog = "https://github.com/dashea/requests-file/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
