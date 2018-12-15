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
  version = "0.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q26sg0jasday52a7y0cch13l0ssjvr4yqnvswqxsinj1lv5ld88";
  };

  patchPhase = ''
    sed -i 's@python@${python.interpreter}@' .testr.conf
  '';

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
