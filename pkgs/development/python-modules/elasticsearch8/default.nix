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
  version = "8.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mRy48OYsm+0M1/D+abs83RiqN8wQr/Z6SZUY4TNg190=";
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
