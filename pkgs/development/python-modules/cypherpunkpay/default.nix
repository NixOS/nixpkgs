{
  lib,
  stdenv,
  apscheduler,
  bitstring,
  buildPythonPackage,
  cffi,
  ecdsa,
  fetchFromGitHub,
  monero,
  poetry-core,
  pypng,
  pyqrcode,
  pyramid,
  pyramid-jinja2,
  pysocks,
  pytestCheckHook,
  pythonOlder,
  requests,
  tzlocal,
  waitress,
  webtest,
  yoyo-migrations,
}:

buildPythonPackage rec {
  pname = "cypherpunkpay";
  version = "1.0.16";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CypherpunkPay";
    repo = "CypherpunkPay";
    rev = "refs/tags/v${version}";
    hash = "sha256-X0DB0PVwR0gRnt3jixFzglWAOPKBMvqTOG6pK6OJ03w=";
  };

  pythonRelaxDeps = [
    "bitstring"
    "cffi"
    "ecdsa"
    "pypng"
    "tzlocal"
    "yoyo-migrations"
    "waitress"
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    apscheduler
    bitstring
    cffi
    ecdsa
    monero
    pypng
    pyqrcode
    pyramid
    pyramid-jinja2
    pysocks
    requests
    tzlocal
    waitress
    yoyo-migrations
  ];

  nativeCheckInputs = [
    pytestCheckHook
    webtest
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # performance test
    "tests/unit/tools/pbkdf2_test.py"
    # tests require network connection
    "tests/network/explorers/bitcoin"
    "tests/network/monero/monero_address_transactions_db_test.py"
    "tests/network/net/http_client"
    "tests/network/prices"
    # tests require bitcoind running
    "tests/network/full_node_clients"
    # tests require lnd running
    "tests/network/ln"
    # tests require tor running
    "tests/network/monero/monero_test.py"
    "tests/network/net/tor_client"
    "tests/network/usecases/calc_monero_address_credits_uc_test.py"
    "tests/network/usecases/fetch_monero_txs_from_open_node_uc_test.py"
    # tests require the full environment running
    "tests/acceptance/views"
    "tests/acceptance/views_admin"
    "tests/acceptance/views_donations"
    "tests/acceptance/views_dummystore"
  ];

  pythonImportsCheck = [ "cypherpunkpay" ];

  meta = with lib; {
    description = "Modern self-hosted software for accepting Bitcoin";
    homepage = "https://github.com/CypherpunkPay/CypherpunkPay";
    changelog = "https://github.com/CypherpunkPay/CypherpunkPay/releases/tag/v${version}";
    license = with licenses; [
      mit # or
      unlicense
    ];
    maintainers = with maintainers; [ prusnak ];
  };
}
