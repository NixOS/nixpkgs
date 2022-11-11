{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, APScheduler
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
}:

buildPythonPackage rec {
  pname = "cypherpunkpay";
  version = "1.0.16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "CypherpunkPay";
    repo = "CypherpunkPay";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-X0DB0PVwR0gRnt3jixFzglWAOPKBMvqTOG6pK6OJ03w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'monero = "^0.99"' 'monero = ">=0.99"' \
      --replace 'pypng = "^0.0.20"' 'pypng = ">=0.0.20"' \
      --replace 'tzlocal = "2.1"' 'tzlocal = ">=2.1"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    APScheduler
    bitstring
    cffi
    ecdsa
    monero
    pypng
    pyqrcode
    pyramid
    pyramid_jinja2
    pysocks
    requests
    tzlocal
    waitress
    yoyo-migrations
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    webtest
  ];

  disabledTestPaths = [
    # performance test
    "test/unit/tools/pbkdf2_test.py"
    # tests require network connection
    "test/network/explorers/bitcoin"
    "test/network/net/http_client"
    "test/network/prices"
    # tests require bitcoind running
    "test/network/full_node_clients"
    # tests require lnd running
    "test/network/ln"
    # tests require tor running
    "test/network/net/tor_client"
    # tests require the full environment running
    "test/acceptance/views"
    "test/acceptance/views_admin"
    "test/acceptance/views_donations"
    "test/acceptance/views_dummystore"
  ];

  meta = with lib; {
    description = "Modern self-hosted software for accepting Bitcoin";
    homepage = "https://cypherpunkpay.org";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ prusnak ];
  };
}
