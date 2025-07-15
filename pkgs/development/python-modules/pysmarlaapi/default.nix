{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  jsonpickle,
  lib,
  pysignalr,
}:

buildPythonPackage rec {
  pname = "pysmarlaapi";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Explicatis-GmbH";
    repo = "pysmarlaapi";
    tag = version;
    hash = "sha256-f8cghqdR4nxyBoMJiHWpZAzxcKMBmcKSqkLGtls2MwA=";
  };

  build-system = [ flit-core ];

  pythonRelaxDeps = true;

  dependencies = [
    aiohttp
    jsonpickle
    pysignalr
  ];

  pythonImportsCheck = [ "pysmarlaapi" ];

  meta = {
    changelog = "https://github.com/Explicatis-GmbH/pysmarlaapi/releases/tag/${src.tag}";
    description = "Swing2Sleep Smarla API";
    homepage = "https://github.com/Explicatis-GmbH/pysmarlaapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
