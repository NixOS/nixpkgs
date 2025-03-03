{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiobotocore,
  aiohttp,
  attr,
  aws-request-signer,
  botocore,
  requests-aws4auth,
  pycognito,
}:

buildPythonPackage rec {
  pname = "aioaquacell";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n2kPD1t5d/nf43rB0q1hNNYdHeaBiadsFWTmu1bYN1A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiobotocore
    attr
    aws-request-signer
    botocore
    requests-aws4auth
    pycognito
  ];

  pythonImportsCheck = [ "aioaquacell" ];

  doCheck = false;

  meta = {
    changelog = "https://github.com/Jordi1990/aioaquacell/releases/tag/v${version}";
    description = "Asynchronous library to retrieve details of your Aquacell water softener device.";
    homepage = "https://github.com/Jordi1990/aioaquacell";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
