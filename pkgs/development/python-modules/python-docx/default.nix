{ lib
, behave
, buildPythonPackage
, fetchPypi
, lxml
, mock
, pyparsing
, pytestCheckHook
, pythonOlder
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "python-docx";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WCm3IhQc8at5rt8MNNn+mSSyl2RYTA8hZOsrAtzfF8k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "docx"
  ];

  meta = with lib; {
    description = "Create and update Microsoft Word .docx files";
    homepage = "https://python-docx.readthedocs.io/";
    changelog = "https://github.com/python-openxml/python-docx/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ alexchapman ];
  };
}
