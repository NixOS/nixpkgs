{
  lib,
  buildPythonPackage,
  fetchPypi,
  async-timeout,
  pysnmp,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    homepage = "https://github.com/mtdcr/pductl";
    changelog = "https://github.com/mtdcr/pductl/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pductl";
  };
}
