{ buildPythonPackage
, fetchPypi
, urllib3, requests
, nosexcover, mock
, stdenv
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "6.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d91a3fce12123a187b673f18c23bcffa6e7b49ba057555d59eeeded0ba15dce";
  };

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;
  propagatedBuildInputs = [ urllib3 requests ];
  buildInputs = [ nosexcover mock ];

  meta = with stdenv.lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = https://github.com/elasticsearch/elasticsearch-py;
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
})
