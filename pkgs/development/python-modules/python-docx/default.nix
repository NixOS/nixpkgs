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
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-openxml";
    repo = "python-docx";
    tag = "v${version}";
    hash = "sha256-isxMtq5j5J02GcHMzOJdJw+ZokLoxA6fG1xsN21Irbc=";
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
