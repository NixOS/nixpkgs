{
  lib,
  buildPythonPackage,
  fetchPypi,
  elasticsearch,
  python-dateutil,
  six,
}:

buildPythonPackage rec {
  pname = "elasticsearch-dsl";
  version = "8.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cy/IEae7B2O8P7WJLk6nzwbTG7o1XoezM1PpLfrNebQ=";
  };

  propagatedBuildInputs = [
    elasticsearch
    python-dateutil
    six
  ];

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
