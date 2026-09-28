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
  version = "1.3.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "pluthon";
    tag = version;
    hash = "sha256-9I4GLdaBxp1xG/3rFZvagugIhB0Vs21bMzPTI1/eKcE=";
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
