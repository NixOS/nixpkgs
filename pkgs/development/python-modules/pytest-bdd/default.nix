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
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytest-bdd";
  version = "8.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-bdd";
    tag = version;
    hash = "sha256-jxrjUXmyDEfw1sxwnlSUAfz3Kkv/4TwKFx7cone0Eyw=";
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

  meta = {
    description = "BDD library for the pytest";
    homepage = "https://github.com/pytest-dev/pytest-bdd";
    changelog = "https://github.com/pytest-dev/pytest-bdd/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jm2dev ];
    mainProgram = "pytest-bdd";
  };
}
