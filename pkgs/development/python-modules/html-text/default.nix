{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  lxml-html-clean,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "html-text";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zytedata";
    repo = "html-text";
    tag = version;
    hash = "sha256-e9gkibQv8mn1Jbt77UmpauOeTqhJQhY9R5Sge/iYi+U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    lxml-html-clean
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "html_text" ];

  meta = with lib; {
    description = "Extract text from HTML";
    homepage = "https://github.com/zytedata/html-text";
    changelog = "https://github.com/zytedata/html-text/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
