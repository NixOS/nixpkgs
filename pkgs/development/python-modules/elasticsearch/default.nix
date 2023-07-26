{ buildPythonPackage
, fetchPypi
, urllib3, requests
, nosexcover, mock
, lib
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "7.16.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8adf8bc351ed55df7296be1009d38a1c999c0abc7d8700fa88533f1ad6087c5e";
  };

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
