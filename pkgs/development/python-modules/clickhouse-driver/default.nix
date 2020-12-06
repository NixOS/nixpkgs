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
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1827cm5z2zd6mxn9alq54bbzw6vhz4a30a54vacqn7nz691qs1gd";
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
