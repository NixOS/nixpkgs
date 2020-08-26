{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, elasticsearch
, ipaddress
, python-dateutil
, six
}:

buildPythonPackage rec {
  pname = "elasticsearch-dsl";
  version = "7.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e345535164cb684de4b825e1d0daf81b75554b30d3905446584a9e4af0cc3e7";
  };

  propagatedBuildInputs = [ elasticsearch python-dateutil six ]
                          ++ stdenv.lib.optional (!isPy3k) ipaddress;

  # ImportError: No module named test_elasticsearch_dsl
  # Tests require a local instance of elasticsearch
  doCheck = false;

  meta = with stdenv.lib; {
    description = "High level Python client for Elasticsearch";
    longDescription = ''
      Elasticsearch DSL is a high-level library whose aim is to help with
      writing and running queries against Elasticsearch. It is built on top of
      the official low-level client (elasticsearch-py).
    '';
    homepage = "https://github.com/elasticsearch/elasticsearch-dsl-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
