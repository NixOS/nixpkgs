{ lib
, buildPythonPackage
, aiocoap
, bleak
, bleak-retry-connector
, chacha20poly1305
, chacha20poly1305-reuseable
, commentjson
, cryptography
, fetchFromGitHub
, orjson
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "aiohomekit";
  version = "2.2.14";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0O8fax25vabItFnUD9N7C4gyMSKPHqHSgzJXJjp5dGw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiocoap
    bleak
    bleak-retry-connector
    chacha20poly1305
    chacha20poly1305-reuseable
    commentjson
    cryptography
    orjson
    zeroconf
  ];

  doCheck = lib.versionAtLeast pytest-aiohttp.version "1.0.0";

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_ip_pairing.py"
  ];

  pythonImportsCheck = [
    "aiohomekit"
  ];

  meta = with lib; {
    description = "Python module that implements the HomeKit protocol";
    longDescription = ''
      This Python library implements the HomeKit protocol for controlling
      Homekit accessories.
    '';
    homepage = "https://github.com/Jc2k/aiohomekit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
