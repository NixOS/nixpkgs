{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asyncmy";
  version = "0.2.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "long2ice";
    repo = "asyncmy";
    tag = "v${version}";
    hash = "sha256-HQZmt22yPYaWfJzL20+jBc855HR4dVW983Z0LrN1Xa0=";
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  # Not running tests as aiomysql is missing support for pymysql>=0.9.3
  doCheck = false;

  pythonImportsCheck = [ "asyncmy" ];

  meta = with lib; {
    description = "Python module to interact with MySQL/mariaDB";
    homepage = "https://github.com/long2ice/asyncmy";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
