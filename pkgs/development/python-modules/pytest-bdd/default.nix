{ lib
, buildPythonPackage
, fetchFromGitHub
, mako
, parse
, parse-type
, poetry-core
, pytest
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "7.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PC4VSsUU5qEFp/C/7OTgHINo8wmOo0w2d1Hpe0EnFzE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    mako
    parse
    parse-type
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [
    "pytest_bdd"
  ];

  meta = with lib; {
    description = "BDD library for the pytest";
    mainProgram = "pytest-bdd";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
