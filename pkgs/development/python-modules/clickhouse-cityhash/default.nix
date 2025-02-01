{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "clickhouse-cityhash";
  version = "1.0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ezEl19CqE8LMTnWDqWWmv7CqlqEhMUdbRCVSustV9Pg=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  doCheck = false;

  pythonImportsCheck = [ "clickhouse_cityhash" ];

  meta = with lib; {
    description = "Python-bindings for CityHash, a fast non-cryptographic hash algorithm";
    homepage = "https://github.com/xzkostyan/python-cityhash";
    license = licenses.upl;
    maintainers = with maintainers; [ breakds ];
  };
}
