{ buildPythonPackage
, fetchPypi
, lib
, sphinx
, flake8
, pytest
, pytestcov
, pytest-flakes
, pytestpep8
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dac62e53e5670cb40d2ee4cdc785e6b829665932c3ee75307ad677cf5f7d2e9f";
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
    homepage = https://github.com/WoLpH/portalocker;
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
