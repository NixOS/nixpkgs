{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "clickhouse-cityhash";
  version = "1.0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z8nl0ly2p1h6nygwxs6y40q8y424w40fkjv3jyf8vvcg4h7sdrg";
  };

  propagatedBuildInputs = [ setuptools ];

  doCheck = false;
  pythonImportsCheck = [ "clickhouse_cityhash" ];

  meta = with lib; {
    description = "Python-bindings for CityHash, a fast non-cryptographic hash algorithm";
    homepage = "https://github.com/xzkostyan/python-cityhash";
    license = licenses.upl;
    maintainers = with maintainers; [ breakds ];
  };
}
