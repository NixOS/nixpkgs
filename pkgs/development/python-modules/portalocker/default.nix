{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pytest-mypy
, redis
}:

buildPythonPackage rec {
  version = "2.4.0";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pkitdhuOonNwy1kVNQEizYB7gg0hk+1cnMKPFj32N/Q=";
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
