{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestflakes, pytestpep8, tox }:
buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.8.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17vly6fg0s95lbg620g9dp9jjf12sj4hpbi7cg579kswabl6304g";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytestflakes pytestpep8 tox ];

  meta = with stdenv.lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "pytest plugin to generate random data inspired by QuickCheck";
  };
}
