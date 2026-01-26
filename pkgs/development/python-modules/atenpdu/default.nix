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
  version = "0.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BcCw5y5LB0jLp9dRP0ZsAObTZ07kS+h+Hm8PZ0NwU3E=";
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
