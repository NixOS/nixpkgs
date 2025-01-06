{
  lib,
  aiohttp,
  buildPythonPackage,
  certifi,
  elastic-transport,
  fetchPypi,
  pythonOlder,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "elasticsearch";
  version = "8.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qiSQAp3Zb0AVszPBgnqiH9bApNIjsA37D+kzuNCaURs=";
  };

  nativeBuildInputs = [ elastic-transport ];

  propagatedBuildInputs = [
    urllib3
    certifi
  ];

  optional-dependencies = {
    requests = [ requests ];
    async = [ aiohttp ];
  };

  pythonImportsCheck = [ "elasticsearch" ];

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
