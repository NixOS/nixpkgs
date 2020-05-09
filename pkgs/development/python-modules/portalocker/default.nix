{ buildPythonPackage
, fetchPypi
, lib
, fetchpatch
, sphinx
, flake8
, pytest
, pytestcov
, pytest-flakes
, pytestpep8
}:

buildPythonPackage rec {
  version = "1.7.0";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p32v16va780mjjdbyp3v702aqg5s618khlila7bdyynis1n84q9";
  };

  checkInputs = [
    sphinx
    flake8
    pytest
    pytestcov
    pytest-flakes
    pytestpep8
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
