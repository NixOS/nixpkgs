{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pylint-venv";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jgosmann";
    repo = "pylint-venv";
    tag = "v${version}";
    hash = "sha256-dJWVfltze4zT0CowBZSn3alqR2Y8obKUCmO8Nfw+ahs=";
  };

  build-system = [ poetry-core ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pylint_venv" ];

  meta = {
    description = "Module to make pylint respect virtual environments";
    homepage = "https://github.com/jgosmann/pylint-venv/";
    changelog = "https://github.com/jgosmann/pylint-venv/blob/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
