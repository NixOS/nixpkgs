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
  version = "1.5.0";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08y5k39mn5a7n69wv0hsyjqb51lazs4i4dpxp42nla2lhllnpbyr";
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
