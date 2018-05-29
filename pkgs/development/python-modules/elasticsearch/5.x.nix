{ buildPythonPackage
, fetchPypi
, urllib3, requests
, stdenv
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "5.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kx9p1mpg8q71b1r0qr2j966anm3as04afl92ybd02ps6c6f6fc5";
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
