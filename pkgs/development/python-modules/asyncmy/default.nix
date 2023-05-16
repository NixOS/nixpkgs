{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, poetry-core
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "asyncmy";
<<<<<<< HEAD
  version = "0.2.8";
=======
  version = "0.2.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "long2ice";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-2DqQclwTfHo3YFlJ7xL3cVnhGyS4ZE7VYYv6TBqRNL0=";
=======
    hash = "sha256-mkYh1fmhtBZ2DyL7a2RduTm+ig4Xnk5Ps1Tm0DS/OEc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  # Not running tests as aiomysql is missing support for pymysql>=0.9.3
  doCheck = false;

  pythonImportsCheck = [
    "asyncmy"
  ];

  meta = with lib; {
    description = "Python module to interact with MySQL/mariaDB";
    homepage = "https://github.com/long2ice/asyncmy";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
