{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, fixtures
, subunit
, testrepository
, testtools
, six
, openstackdocstheme
, sphinx
, stestr
, coverage
, flake8
, isPy36
}:

buildPythonPackage rec {
  pname = "mox3";
  version = "0.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b13c0b8459d6fb0688f9a4e70feeec43fa2cca05b727fc01156789596e083bb1";
  };

  # Relax version contraint
  patchPhase = ''
    sed -i 's/flake8<2.6.0,>=2.5.4/flake8>=2.5.4/' test-requirements.txt
  '';

  # All but 3 tests pass in pyhon3.6
  #  FAIL: mox3.tests.test_mox.RegexTest.testReprWithFlags
  #  ValueError: cannot use LOCALE flag with a str pattern
  doCheck = !isPy36;

  checkInputs = [ subunit testrepository testtools six openstackdocstheme sphinx stestr coverage flake8 ];
  propagatedBuildInputs = [ pbr fixtures ];

  meta = with stdenv.lib; {
    homepage = https://docs.openstack.org/mox3/latest/;
    description = "Mock object framework for Python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
