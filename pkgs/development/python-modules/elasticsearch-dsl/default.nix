{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, elasticsearch
, ipaddress
, python-dateutil
, six
}:

buildPythonPackage rec {
  pname = "elasticsearch-dsl";
  version = "7.4.0";

  src = fetchFromGitHub {
     owner = "elasticsearch";
     repo = "elasticsearch-dsl-py";
     rev = "v7.4.0";
     sha256 = "1zg6bl99kw5igksc77pmdlm4i49n1rjvnw7pw4f4gvar4yp6lkd4";
  };

  propagatedBuildInputs = [ elasticsearch python-dateutil six ]
                          ++ lib.optional (!isPy3k) ipaddress;

  # ImportError: No module named test_elasticsearch_dsl
  # Tests require a local instance of elasticsearch
  doCheck = false;

  meta = with lib; {
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
