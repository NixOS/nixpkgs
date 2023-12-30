{ buildPythonPackage, fetchFromGitHub, fluent-syntax, lib, pygments, pythonOlder, setuptools }:

buildPythonPackage {
  pname = "fluent-pygments";
  version = "unstable-2021-04-09";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "projectfluent";
    repo = "python-fluent";
    rev = "c58681f1e90c14dd36c2ff35d7d487235b685177";
    hash = "sha256-89kqUlHZzn54M6xm0kB1phCJ+TssFC9wPp+JdS+IGDY=";
  };

  setSourceRoot = "sourceRoot=$(echo */fluent.pygments)";

  propagatedBuildInputs = [
    fluent-syntax
    pygments
    setuptools
  ];

  pythonImportsCheck = [
    "fluent.pygments"
  ];

  meta = with lib; {
    description = "Pygments lexer for Fluent";
    homepage = "https://projectfluent.org/python-fluent";
    changelog = "https://github.com/projectfluent/python-fluent/blob/main/fluent.pygments/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ getpsyched ];
    platforms = platforms.all;
  };
}
