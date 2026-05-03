{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "pysignalclirestapi";
  version = "0.3.25";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbernhard";
    repo = "pysignalclirestapi";
    tag = version;
    hash = "sha256-pMijhYKcy1w6aVKdpMU3e0CF48SMa7uQS7ky2Ifaq1w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    six
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysignalclirestapi" ];

  meta = {
    changelog = "https://github.com/bbernhard/pysignalclirestapi/releases/tag/${version}";
    description = "Small python library for the Signal Cli REST API";
    homepage = "https://github.com/bbernhard/pysignalclirestapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
