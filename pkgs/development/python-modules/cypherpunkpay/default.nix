<<<<<<< HEAD
{ lib
, stdenv
, apscheduler
, bitstring
, buildPythonPackage
, cffi
, ecdsa
, fetchFromGitHub
, monero
, poetry-core
, pypng
, pyqrcode
, pyramid
, pyramid-jinja2
, pysocks
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, tzlocal
, waitress
, webtest
, yoyo-migrations
=======
{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, apscheduler
, bitstring
, cffi
, ecdsa
, monero
, pypng
, pyqrcode
, pyramid
, pyramid_jinja2
, pysocks
, requests
, tzlocal
, waitress
, yoyo-migrations
, pytestCheckHook
, pytest-cov
, webtest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cypherpunkpay";
  version = "1.0.16";
  format = "pyproject";

<<<<<<< HEAD
  disabled = pythonOlder "3.7";

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "CypherpunkPay";
    repo = "CypherpunkPay";
    rev = "refs/tags/v${version}";
    hash = "sha256-X0DB0PVwR0gRnt3jixFzglWAOPKBMvqTOG6pK6OJ03w=";
  };

<<<<<<< HEAD
  pythonRelaxDeps = [
    "bitstring"
    "cffi"
    "ecdsa"
    "pypng"
    "tzlocal"
    "yoyo-migrations"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "bitstring = '^3.1.9'" "bitstring = '>=3.1.9'" \
      --replace 'cffi = "1.15.0"' 'cffi = ">=1.15.0"' \
      --replace 'ecdsa = "^0.17.0"' 'ecdsa = ">=0.17.0"' \
      --replace 'pypng = "^0.0.20"' 'pypng = ">=0.0.20"' \
      --replace 'tzlocal = "2.1"' 'tzlocal = ">=2.1"'
  '';

  nativeBuildInputs = [
    poetry-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pyramid-jinja2
=======
    pyramid_jinja2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pysocks
    requests
    tzlocal
    waitress
    yoyo-migrations
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
    webtest
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

=======
    pytest-cov
    webtest
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  pythonImportsCheck = [
    "cypherpunkpay"
  ];

  meta = with lib; {
    description = "Modern self-hosted software for accepting Bitcoin";
    homepage = "https://github.com/CypherpunkPay/CypherpunkPay";
    changelog = "https://github.com/CypherpunkPay/CypherpunkPay/releases/tag/v${version}";
=======
  meta = with lib; {
    description = "Modern self-hosted software for accepting Bitcoin";
    homepage = "https://cypherpunkpay.org";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ prusnak ];
  };
}
