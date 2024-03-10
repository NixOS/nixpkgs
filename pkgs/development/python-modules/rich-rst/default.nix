{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, docutils
, rich
}:

buildPythonPackage rec {
  pname = "rich-rst";
  version = "1.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jFPboZ5/T2I6EuyVM+45lrLWen8Kqf94gWXS1WDf1qU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ docutils rich ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "rich_rst" ];

  meta = with lib; {
    description = "A beautiful reStructuredText renderer for rich";
    homepage = "https://github.com/wasi-master/rich-rst";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
