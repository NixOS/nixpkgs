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
  version = "0.2.0";

  # pypi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "mymarilyn";
    repo = "clickhouse-driver";
    rev = "96b7ba448c63ca2670cc9aa70d4a0e08826fb650";
    sha256 = "sha256-HFKUxJOlBCVlu7Ia8heGpwX6+HdKuwSy92s3v+GKGwE=";
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

  pytestFlagsArray = [ "-n" "$NIX_BUILD_CORES" ];

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
