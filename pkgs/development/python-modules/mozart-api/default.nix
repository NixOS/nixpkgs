{
  lib,
  buildPythonPackage,
  fetchPypi,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  poetry-core,
  aenum,
  aioconsole,
  aiohttp,
<<<<<<< HEAD
  aiohttp-retry,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  inflection,
  pydantic,
  python-dateutil,
  typing-extensions,
  urllib3,
  websockets,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "mozart-api";
<<<<<<< HEAD
  version = "5.3.1.108.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mozart_api";
    inherit version;
    hash = "sha256-12qjXQKQS3k1hDRLW0UkR5OqHM/QmXKOnfoJVguhHWQ=";
=======
  version = "4.1.1.116.6";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "mozart_api";
    inherit version;
    hash = "sha256-0TZHH/EXemsSysgfCzg66x5QhAEDUqRyg+qoK/3YuQA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
<<<<<<< HEAD
    aioconsole
    aiohttp
    aiohttp-retry
=======
    aenum
    aioconsole
    aiohttp
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inflection
    pydantic
    python-dateutil
    typing-extensions
    urllib3
    websockets
    zeroconf
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "mozart_api" ];

  meta = {
    description = "REST API for the Bang & Olufsen Mozart platform";
    homepage = "https://github.com/bang-olufsen/mozart-open-api";
    changelog = "https://github.com/bang-olufsen/mozart-open-api/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
