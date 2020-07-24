{ buildPythonPackage
, fetchPypi
, urllib3, requests
, nosexcover, mock
, stdenv
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "7.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14m7lfn36y0bjlpqxd7j9ggvbx46q30fva4czyspkqi79v7xhdz6";
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
