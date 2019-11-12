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
  version = "1.5.1";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08d8vm373fbx90wrql2i7025d4ir54sq8ahx6g1pw9h793zqrn0y";
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
