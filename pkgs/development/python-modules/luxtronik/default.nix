{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "luxtronik";
  version = "0.3.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = "python-luxtronik";
    rev = version;
    hash = "sha256-7TuvqOAb/MUumOF6BKTRLOJuvteqZPmFUXXsuwEpmOM=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "luxtronik" ];

  meta = {
    description = "Python library to interact with Luxtronik heatpump controllers";
    homepage = "https://github.com/Bouni/python-luxtronik";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
