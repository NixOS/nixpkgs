{ buildPythonPackage
, fetchPypi
, urllib3, requests
, nosexcover, mock
, lib
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  # In 7.14.0, the package was intentionally made incompatible with
  # the OSS version of elasticsearch - don't update past 7.13.x until
  # there's a clear path forward. See
  # https://github.com/elastic/elasticsearch-py/issues/1639 for more
  # info.
  version = "7.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7f8665715ad80e3e99e42388bcc49c1b06162f72acfa1f8febe2baf5570b0ed";
  };

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;
  propagatedBuildInputs = [ urllib3 requests ];
  buildInputs = [ nosexcover mock ];

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
})
