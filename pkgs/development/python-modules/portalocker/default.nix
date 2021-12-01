{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pytest-mypy
, redis
}:

buildPythonPackage rec {
  version = "2.3.2";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75cfe02f702737f1726d83e04eedfa0bda2cc5b974b1ceafb8d6b42377efbd5f";
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
