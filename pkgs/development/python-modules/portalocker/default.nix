{ lib, buildPythonPackage, fetchPypi, fetchpatch
, sphinx
, pytest
, pytestcov
, pytest-flake8
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r165ll4gnsbgvf9cgdkbg04526aqwllwa7hxlkl34dah7npwj0l";
  };

  checkInputs = [
    sphinx
    pytest
    pytestcov
    pytest-flake8
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
