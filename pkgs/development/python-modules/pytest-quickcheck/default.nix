{ stdenv, buildPythonPackage, fetchPypi, pytest, pytest-flakes, pytestpep8, tox }:
buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e368390c9e3fd48eb3edec0c4eef08d7332f1143ad7b7190d32376b2fd2e62ff";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytest-flakes pytestpep8 tox ];

  meta = with stdenv.lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "pytest plugin to generate random data inspired by QuickCheck";
  };
}
