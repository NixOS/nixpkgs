{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  # Python deps
  uplc,
  ordered-set,
}:

buildPythonPackage rec {
  pname = "pluthon";
  version = "1.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "pluthon";
    rev = version;
    hash = "sha256-t8KWm2eBq6CzFPAWN9pgbpF62hvNNZWCpphJsY5T2OQ=";
  };

  propagatedBuildInputs = [
    setuptools
    uplc
    ordered-set
  ];

  pythonImportsCheck = [ "pluthon" ];

  meta = {
    description = "Pluto-like programming language for Cardano Smart Contracts in Python";
    homepage = "https://github.com/OpShin/pluthon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
  };
}
