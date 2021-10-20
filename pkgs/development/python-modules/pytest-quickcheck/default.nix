{ lib, buildPythonPackage, fetchPypi, pytest, pytest-flakes, tox }:
buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ef9bde7ba1fe6470c5b61631440186d1254e276c67a527242d91451ab7994e5";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytest-flakes tox ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "pytest plugin to generate random data inspired by QuickCheck";
    broken = true; # missing pytest-codestyle
  };
}
