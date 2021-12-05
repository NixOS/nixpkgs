{ lib, buildPythonPackage, cython, fetchFromGitHub, poetry-core, pythonOlder }:

buildPythonPackage rec {
  pname = "asyncmy";
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "long2ice";
    repo = pname;
    rev = "v${version}";
    sha256 = "ys9RYaosc4noJsWYsVo9+6W7JaG4r6lsz6UH4o08q4A=";
  };

  nativeBuildInputs = [ cython poetry-core ];

  # Not running tests as aiomysql is missing support for
  # pymysql>=0.9.3
  doCheck = false;

  pythonImportsCheck = [ "asyncmy" ];

  meta = with lib; {
    description = "Python module to interact with MySQL/mariaDB";
    homepage = "https://github.com/long2ice/asyncmy";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
