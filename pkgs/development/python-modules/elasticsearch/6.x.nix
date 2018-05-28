{ buildPythonPackage
, fetchPypi
, urllib3, requests
, stdenv
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b106fa3e01750376a42f8a9882bd84d630fda58c7aba38b4fec797d11c0bd0a2";
  };
  propagatedBuildInputs = [ urllib3 requests ];

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = https://github.com/elasticsearch/elasticsearch-py;
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
})
