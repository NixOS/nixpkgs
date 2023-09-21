{ lib
, stdenv
, buildPythonPackage
, dnspython
, fetchFromGitHub
, iana-etc
, libredirect
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "ipwhois";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "secynic";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2CfRRHlIIaycUtzKeMBKi6pVPeBCb1nW3/1hoxQU1YM=";
  };

  pythonRelaxDeps = [
    "dnspython"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    dnspython
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ipwhois"
  ];

  preCheck = lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  disabledTestPaths = [
    # Tests require network access
    "ipwhois/tests/online/"
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
