{ buildPythonPackage
, fetchPypi
, setuptools
, urllib3, requests
, nosexcover, mock
, lib
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "8.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nghBO+r/Oka8EMbFcGmoRwTfaqqTCFxzffB/WKKBG3g=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;
  propagatedBuildInputs = [ urllib3 requests ];
  buildInputs = [ nosexcover mock ];

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
})
