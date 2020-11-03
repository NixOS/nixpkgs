{ buildPythonPackage
, fetchPypi
, urllib3, requests
, nosexcover, mock
, stdenv
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "7.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e08776fbb30c6e92408c7fa8c37d939210d291475ae2f364f0497975918b6fe";
  };

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;
  requiredPythonModules = [ urllib3 requests ];
  buildInputs = [ nosexcover mock ];

  meta = with stdenv.lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
})
