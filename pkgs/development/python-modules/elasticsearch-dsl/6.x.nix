{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, elasticsearch_6
, ipaddress
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  pname = "elasticsearch-dsl";
  version = "6.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ckjpi1q12yyhdf371wqqhrs6jq8x2hhgbifg1ilcfp9i25a652i";
  };

  propagatedBuildInputs = [ elasticsearch_6 python-dateutil pytz ] ++ stdenv.lib.optional (!isPy3k) ipaddress;

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
    homepage = https://github.com/elasticsearch/elasticsearch-dsl-py;
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
