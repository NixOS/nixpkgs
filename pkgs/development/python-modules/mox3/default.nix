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
  version = "0.27.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "210ccaf5829de3e133f0fb8ab798cdb82663aae09b715130fc4765f18234162a";
  };


  buildInputs = [ subunit testrepository testtools six ];
  propagatedBuildInputs = [ pbr fixtures ];

  #  FAIL: mox3.tests.test_mox.RegexTest.testReprWithFlags
  #  ValueError: cannot use LOCALE flag with a str pattern
  doCheck = !isPy36;

  meta = with stdenv.lib; {
    description = "Mock object framework for Python";
    homepage = https://docs.openstack.org/mox3/latest/;
    license = licenses.asl20;
  };

}
