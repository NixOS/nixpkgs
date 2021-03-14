{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytz
, tzlocal
, clickhouse-cityhash
, zstd
, lz4
, freezegun
, mock
, nose
}:

buildPythonPackage rec {
  pname = "clickhouse-driver";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62d37f93872d5a13eb6b0d52bab2b593ed0e14cf9200949aa2d02f9801064c0f";
  };

  propagatedBuildInputs = [
    setuptools
    pytz
    tzlocal
    clickhouse-cityhash
    zstd
    lz4
  ];

  checkInputs = [
    freezegun
    mock
    nose
  ];

  doCheck = true;
  pythonImportsCheck = [ "clickhouse_driver" ];

  meta = with lib; {
    description = "Python driver with native interface for ClickHouse";
    homepage = "https://github.com/mymarilyn/clickhouse-driver";
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
