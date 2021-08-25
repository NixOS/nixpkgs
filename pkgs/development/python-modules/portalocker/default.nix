{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pytest-mypy
, redis
}:

buildPythonPackage rec {
  version = "2.3.1";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ff2e494eccd3ff1cbaba8e4defd45bc7edb8eea3908c74f6de5d40641a1ed92";
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
