{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mako,
  parse,
  parse-type,
  poetry-core,
  pytest,
  pytest7CheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "7.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-bdd";
    tag = version;
    hash = "sha256-PC4VSsUU5qEFp/C/7OTgHINo8wmOo0w2d1Hpe0EnFzE=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  dependencies = [
    mako
    parse
    parse-type
    typing-extensions
  ];

  # requires an update for pytest 8.4 compat
  nativeCheckInputs = [ pytest7CheckHook ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pythonImportsCheck = [ "pytest_bdd" ];

  meta = with lib; {
    description = "BDD library for the pytest";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    changelog = "https://github.com/pytest-dev/pytest-bdd/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
    mainProgram = "pytest-bdd";
  };
}
