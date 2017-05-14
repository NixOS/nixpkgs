{ stdenv, buildPythonPackage, fetchPypi
, urllib3
}:

buildPythonPackage rec {
  pname = "elasticsearch";
  version = "2.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fead47ebfcaabd1c53dbfc21403eb99ac207eef76de8002fe11a1c8ec9589ce2";
  };

  # Tests are not distributed
  doCheck = false;

  propagatedBuildInputs = [ urllib3 ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/elastic/elasticsearch-py";
    license = licenses.asl20;
    description = "Python client for Elasticsearch";
  };
}
