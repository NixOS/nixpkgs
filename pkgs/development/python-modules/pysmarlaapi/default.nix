{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  jsonpickle,
  lib,
  pysignalr,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysmarlaapi";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Explicatis-GmbH";
    repo = "pysmarlaapi";
    tag = finalAttrs.version;
    hash = "sha256-teRdxYe9thM22tZ09FHxOxxzy4gcfJBAylgpk34ISTk=";
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
    changelog = "https://github.com/Explicatis-GmbH/pysmarlaapi/releases/tag/${finalAttrs.src.tag}";
    description = "Swing2Sleep Smarla API";
    homepage = "https://github.com/Explicatis-GmbH/pysmarlaapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
