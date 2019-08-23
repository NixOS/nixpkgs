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
  version = "0.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b13c0b8459d6fb0688f9a4e70feeec43fa2cca05b727fc01156789596e083bb1";
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
