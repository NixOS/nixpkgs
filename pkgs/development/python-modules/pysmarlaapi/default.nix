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
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.9.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Explicatis-GmbH";
    repo = "pysmarlaapi";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-VnWGBTbs6c5WU1mGcUNRsFjdWUN5yA6TOD9qmQASxIw=";
=======
    hash = "sha256-UNI0T9YVvtfPJJQIA04ofZ42ZvYo7Kli3+snY5RlVBU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
