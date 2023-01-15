{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, docutils
, rich
}:

buildPythonPackage rec {
  pname = "rich-rst";
  version = "1.1.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-s48hdJo1LIRXTf+PeSBa6y/AH1NLmnyAafFydJ+exDk=";
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
