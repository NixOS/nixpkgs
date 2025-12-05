{
  lib,
  behave,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  mock,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-docx";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-openxml";
    repo = "python-docx";
    tag = "v${version}";
    hash = "sha256-5x2VmMiY5fZiXoswCDcs89olL0vbpGzmJZThrNS/SmI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    typing-extensions
  ];

  nativeCheckInputs = [
    behave
    mock
    pyparsing
    pytestCheckHook
  ];

  postCheck = ''
    behave --format progress --stop --tags=-wip
  '';

  pythonImportsCheck = [ "docx" ];

  disabledTests = [
    # https://github.com/python-openxml/python-docx/issues/1302
    "it_accepts_unicode_providing_there_is_no_encoding_declaration"
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Create and update Microsoft Word .docx files";
    homepage = "https://python-docx.readthedocs.io/";
    changelog = "https://github.com/python-openxml/python-docx/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ alexchapman ];
  };
}
