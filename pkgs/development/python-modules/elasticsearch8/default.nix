{ lib
, aiohttp
, buildPythonPackage
, elastic-transport
, fetchPypi
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "elasticsearch8";
<<<<<<< HEAD
  version = "8.9.0";
=======
  version = "8.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-9j71MX3ITwfwFfIVvQIbXHu4r/3qz9SNAz8XfeAyWTc=";
=======
    hash = "sha256-mRy48OYsm+0M1/D+abs83RiqN8wQr/Z6SZUY4TNg190=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    elastic-transport
  ];

  propagatedBuildInputs = [
    requests
  ];

  passthru.optional-dependencies = {
    async = [
      aiohttp
    ];
  };

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/main/test_elasticsearch
  doCheck = false;

  pythonImportsCheck = [
    "elasticsearch8"
  ];

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
