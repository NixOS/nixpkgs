{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "clickhouse-cityhash";
  version = "1.0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ezEl19CqE8LMTnWDqWWmv7CqlqEhMUdbRCVSustV9Pg=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  doCheck = false;

  pythonImportsCheck = [
    "clickhouse_cityhash"
  ];

  meta = with lib; {
    description = "Python-bindings for CityHash, a fast non-cryptographic hash algorithm";
    homepage = "https://github.com/xzkostyan/python-cityhash";
    license = licenses.upl;
    maintainers = with maintainers; [ breakds ];
  };
}
