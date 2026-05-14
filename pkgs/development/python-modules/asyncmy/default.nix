{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncmy";
  version = "0.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "long2ice";
    repo = "asyncmy";
    tag = "v${version}";
    hash = "sha256-+6sXXlSAZr09nPuJtZH8S2UfijFthDpRA/AdGOyIfxU=";
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  # Not running tests as aiomysql is missing support for pymysql>=0.9.3
  doCheck = false;

  pythonImportsCheck = [ "asyncmy" ];

  meta = {
    description = "Python module to interact with MySQL/mariaDB";
    homepage = "https://github.com/long2ice/asyncmy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
