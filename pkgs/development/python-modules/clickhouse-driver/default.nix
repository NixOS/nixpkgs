{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytz
, tzlocal
, clickhouse-cityhash
, zstd
, lz4
, freezegun
, mock
, nose
, pytestCheckHook
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "clickhouse-driver";
  version = "0.2.2";

  # pypi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "mymarilyn";
    repo = "clickhouse-driver";
    rev = version;
    sha256 = "0sx4jbadx9frzhqnj8b9w9l508x1r7j7b9883h7xq93lf00rxkfz";
  };

  propagatedBuildInputs = [
    setuptools
    pytz
    tzlocal
    clickhouse-cityhash
    zstd
    lz4
  ];

  nativeCheckInputs = [
    freezegun
    mock
    nose
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "lz4<=3.0.1" "lz4<=4"
  '';

  # remove source to prevent pytest testing source instead of the build artifacts
  # (the source doesn't contain the extension modules)
  preCheck = ''
    rm -rf clickhouse_driver
  '';

  # some test in test_buffered_reader.py doesn't seem to return
  disabledTestPaths = [ "tests/test_buffered_reader.py" ];

  # most tests require `clickhouse`
  # TODO: enable tests after `clickhouse` unbroken
  doCheck = false;

  pythonImportsCheck = [ "clickhouse_driver" ];

  meta = with lib; {
    description = "Python driver with native interface for ClickHouse";
    homepage = "https://github.com/mymarilyn/clickhouse-driver";
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
