{ buildPythonPackage
, fetchPypi
, urllib3, requests
, nosexcover, mock
, stdenv
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "7.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92b534931865a186906873f75ae0b91808ff5036b0f2b9269eb5f6dc09644b55";
  };

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;
  propagatedBuildInputs = [ urllib3 requests ];
  buildInputs = [ nosexcover mock ];

  meta = with stdenv.lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
})
