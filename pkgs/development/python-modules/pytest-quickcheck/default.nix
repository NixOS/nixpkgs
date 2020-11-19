{ stdenv, buildPythonPackage, fetchPypi, pytest, pytest-flakes, pytestpep8, tox }:
buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2427808b54ccdec26a40cdba934a6c042fab9ebadb60d563a01f367bef87fe58";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytest-flakes pytestpep8 tox ];

  meta = with stdenv.lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "pytest plugin to generate random data inspired by QuickCheck";
    broken = true; # missing pytest-codestyle
  };
}
