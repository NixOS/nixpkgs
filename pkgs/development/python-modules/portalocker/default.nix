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
    sha256 = "17rfgmgwyxyng8q7bvn369cncadqws2wgkg45q6v8337wm9jxins";
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
