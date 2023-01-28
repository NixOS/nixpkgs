{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-flakes
, tox
}:

buildPythonPackage rec {
  pname = "pytest-quickcheck";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UFF8ldnaImXU6al4kGjf720mbwXE6Nut9VlvNVrMVoY=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ pytest-flakes tox ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://pypi.python.org/pypi/pytest-quickcheck";
    description = "pytest plugin to generate random data inspired by QuickCheck";
    maintainers = with maintainers; [ onny ];
    # Pytest support > 6.0 missing
    # https://github.com/t2y/pytest-quickcheck/issues/17
    broken = true;
  };
}
