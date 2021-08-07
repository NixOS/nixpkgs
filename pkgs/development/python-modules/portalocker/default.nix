{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pytest-mypy
, redis
}:

buildPythonPackage rec {
  version = "2.3.0";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k08c0qg21mwz3iqbd20ab22nq705q7cal4a1qr8qnd6ga03v4af";
  };

  propagatedBuildInputs = [
    redis
  ];

  checkInputs = [
    pytestCheckHook
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
