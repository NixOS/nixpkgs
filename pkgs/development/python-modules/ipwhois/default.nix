{
  lib,
  stdenv,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  fetchpatch,
  iana-etc,
  libredirect,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ipwhois";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "secynic";
    repo = "ipwhois";
    rev = "refs/tags/v${version}";
    hash = "sha256-2CfRRHlIIaycUtzKeMBKi6pVPeBCb1nW3/1hoxQU1YM=";
  };

  patches = [
    # Use assertEqual instead of assertEquals, https://github.com/secynic/ipwhois/pull/316
    (fetchpatch {
      name = "assert-equal.patch";
      url = "https://github.com/secynic/ipwhois/commit/fce2761354af99bc169e6cd08057e838fcc40f75.patch";
      hash = "sha256-7Ic4xWTAmklk6MvnZ/WsH9SW/4D9EG/jFKt5Wi89Xtc=";
    })
  ];

  __darwinAllowLocalNetworking = true;

  pythonRelaxDeps = [ "dnspython" ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ dnspython ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ipwhois" ];

  preCheck = lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  disabledTestPaths = [
    # Tests require network access
    "ipwhois/tests/online/"
    # Stress test
    "ipwhois/tests/stress/test_experimental.py"
  ];

  disabledTests = [
    "test_lookup"
    "test_unique_addresses"
    "test_get_http_json"
  ];

  meta = with lib; {
    description = "Library to retrieve and parse whois data";
    homepage = "https://github.com/secynic/ipwhois";
    changelog = "https://github.com/secynic/ipwhois/blob/v${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
