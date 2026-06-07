{
  lib,
  buildPythonPackage,
  fetchPypi,
  async-timeout,
  pysnmp,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+UQVCizqpyVe7nuQUYwSBOtiTwW+0LVH1HaaucnIg9k=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-timeout
    pysnmp
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "atenpdu" ];

  meta = {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    changelog = "https://github.com/mtdcr/pductl/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pductl";
    broken = lib.versionAtLeast pysnmp.version "7";
  };
}
