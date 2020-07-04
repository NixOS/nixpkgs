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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a526b7b9b6341f541a9aef3e08c93fd84a5373fe89d4cc51dd571f085b2363c";
  };

  buildInputs = [ subunit testrepository testtools six ];
  propagatedBuildInputs = [ pbr fixtures ];

  # Disabling as several tests depdencies are missing:
  # https://opendev.org/openstack/mox3/src/branch/master/test-requirements.txt
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mock object framework for Python";
    homepage = "https://docs.openstack.org/mox3/latest/";
    license = licenses.asl20;
  };

}
