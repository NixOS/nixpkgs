{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  python-socks,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-socks";
<<<<<<< HEAD
  version = "0.11.0";
=======
  version = "0.10.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "aiohttp_socks";
<<<<<<< HEAD
    hash = "sha256-Cv5RY4Unx5B35L1uVwUsh8SCQjPW4guwYcU3ZkIbEPA=";
=======
    hash = "sha256-lC18huLleUGPx6c0YQ3ZfarwBwfHRi9sz2ebIyV2eTA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    python-socks
  ]
  ++ python-socks.optional-dependencies.asyncio;

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [ "aiohttp_socks" ];

  meta = {
    description = "SOCKS proxy connector for aiohttp";
    homepage = "https://github.com/romis2012/aiohttp-socks";
    changelog = "https://github.com/romis2012/aiohttp-socks/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
