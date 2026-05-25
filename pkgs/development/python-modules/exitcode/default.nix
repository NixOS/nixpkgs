{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "exitcode";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rumpelsepp";
    repo = "exitcode";
    tag = "v${version}";
    hash = "sha256-MZeLwU1gODqH752y/nc9WkUArl48pyq9Vun7tX620No=";
  };

  nativeBuildInputs = [ poetry-core ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "exitcode" ];

  meta = {
    description = "Preferred system exit codes as defined by sysexits.h";
    homepage = "https://github.com/rumpelsepp/exitcode";
    changelog = "https://github.com/rumpelsepp/exitcode/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
