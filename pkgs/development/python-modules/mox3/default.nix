{ stdenv
, buildPythonPackage
, fetchPypi
, python
, subunit
, testrepository
, testtools
, six
, pbr
, fixtures
, isPy36
}:

buildPythonPackage rec {
  pname = "mox3";
  version = "0.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17d4vglb71s96hhi6d30vnkr7g1pahv95igc4sjv857qf278d540";
  };

  buildInputs = [ subunit testrepository testtools six ];
  propagatedBuildInputs = [ pbr fixtures ];

  # Disabling as several tests depdencies are missing:
  # https://opendev.org/openstack/mox3/src/branch/master/test-requirements.txt
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mock object framework for Python";
    homepage = https://docs.openstack.org/mox3/latest/;
    license = licenses.asl20;
  };

}
