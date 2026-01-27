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
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Explicatis-GmbH";
    repo = "pysmarlaapi";
    tag = version;
    hash = "sha256-aHwmZIesBco6XyxKv321p+0p3Gibvi+X7xs+7RkwbVc=";
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
