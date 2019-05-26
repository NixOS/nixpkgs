{ buildPythonPackage
, fetchPypi
, urllib3, requests
, nosexcover, mock
, stdenv
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "6.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aada5cfdc4a543c47098eb3aca6663848ef5d04b4324935ced441debc11ec98b";
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
