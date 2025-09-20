{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  # Python deps
  requests,
  pexpect,
}:

buildPythonPackage rec {
  pname = "cardano-tools";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "cardano_tools";
    inherit version;
    hash = "sha256-RFyKXHafV+XgRJSsTjASCCw9DxvZqertf4NNN616Bp4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    pexpect
  ];

  pythonImportsCheck = [ "cardano_tools" ];

  meta = {
    description = "Python module for interfacing with the Cardano blockchain";
    homepage = "https://gitlab.com/viperscience/cardano-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aciceri ];
  };
}
