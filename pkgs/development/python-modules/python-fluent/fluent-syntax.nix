{ buildPythonPackage, fetchFromGitHub, lib, pythonOlder, setuptools, typing-extensions }:

buildPythonPackage rec {
  pname = "fluent-syntax";
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = "fluent.syntax@${version}";
    hash = "sha256-nULngwBG/ebICRDi6HMHBdT+r/oq6tbDL7C1iMZpMsA=";
  };

  setSourceRoot = "sourceRoot=$(echo */fluent.syntax)";

  propagatedBuildInputs = [
    setuptools
    typing-extensions
  ];

  pythonImportsCheck = [
    "fluent.syntax"
  ];

  meta = with lib; {
    description = "Localization library for expressive translations";
    homepage = "https://projectfluent.org/python-fluent";
    downloadPage = "https://github.com/projectfluent/python-fluent/releases/tag/fluent.syntax@${version}";
    changelog = "https://github.com/projectfluent/python-fluent/blob/main/fluent.syntax/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ getpsyched ];
    platforms = platforms.all;
  };
}
