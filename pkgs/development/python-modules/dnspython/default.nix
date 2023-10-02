{ lib
, stdenv
, aioquic
, buildPythonPackage
, cacert
, cryptography
, curio
, fetchPypi
, h2
, httpx
, idna
, poetry-core
, pytestCheckHook
, pythonOlder
, requests
, requests-toolbelt
, sniffio
, trio
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jc+ujHRgovhLQHLibxyfQQHKIMBxZJy3w06LapPViYQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  passthru.optional-dependencies = {
    DOH = [
      httpx
      h2
      requests
      requests-toolbelt
    ];
    IDNA = [
      idna
    ];
    DNSSEC = [
      cryptography
    ];
    trio = [
      trio
    ];
    curio = [
      curio
      sniffio
    ];
    DOQ = [
      aioquic
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    cacert
  ] ++ passthru.optional-dependencies.DNSSEC;

  disabledTests = [
    # dns.exception.SyntaxError: protocol not found
    "test_misc_good_WKS_text"
    # fails if IPv6 isn't available
    "test_resolver_override"
  ] ++ lib.optionals stdenv.isDarwin [
    # Tests that run inconsistently on darwin systems
    # 9 tests fail with: BlockingIOError: [Errno 35] Resource temporarily unavailable
    "testQueryUDP"
    # 6 tests fail with: dns.resolver.LifetimeTimeout: The resolution lifetime expired after ...
    "testResolveCacheHit"
    "testResolveTCP"
  ];

  pythonImportsCheck = [
    "dns"
  ];

  meta = with lib; {
    description = "A DNS toolkit for Python";
    homepage = "https://www.dnspython.org";
    changelog = "https://github.com/rthalley/dnspython/blob/v${version}/doc/whatsnew.rst";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ gador ];
  };
}
