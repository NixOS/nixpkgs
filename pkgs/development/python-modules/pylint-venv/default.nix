{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pylint-venv";
  version = "3.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Module to make pylint respect virtual environments";
    homepage = "https://github.com/jgosmann/pylint-venv/";
    changelog = "https://github.com/jgosmann/pylint-venv/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
