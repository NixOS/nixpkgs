{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "html-text";
  version = "0.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zytedata";
    repo = "html-text";
    rev = "refs/tags/${version}";
    hash = "sha256-e9gkibQv8mn1Jbt77UmpauOeTqhJQhY9R5Sge/iYi+U=";
  };

  propagatedBuildInputs = [
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "html_text" ];

  meta = with lib; {
    description = "Extract text from HTML";
    homepage = "https://github.com/zytedata/html-text";
    changelog = "https://github.com/zytedata/html-text/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
  };
}
