{ lib, buildPythonPackage, fetchPypi, fetchpatch
, sphinx
, pytest
, pytestcov
, pytest-flake8
, pytest-mypy
, redis
}:

buildPythonPackage rec {
  version = "2.2.1";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5fb/svNg6a72FafChBQ9KpO7ZAxi6ORacD5gg/xaoRQ=";
  };

  propagatedBuildInputs = [
    redis
  ];

  checkInputs = [
    sphinx
    pytest
    pytestcov
    pytest-flake8
    pytest-mypy
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
