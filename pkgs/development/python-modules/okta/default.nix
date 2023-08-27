{ lib
, stdenv
, aenum
, aiohttp
, buildPythonPackage
, fetchPypi
, flatdict
, pycryptodome
, pycryptodomex
, pydash
, pyfakefs
, pytest-asyncio
, pytest-mock
, pytest-recording
, pytestCheckHook
, python-jose
, pythonOlder
, pyyaml
, xmltodict
, yarl
}:

let
  aenum_fixed = aenum.overridePythonAttrs (oldAttrs: rec {
    version = "3.1.11";
    src = fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      hash = "sha256-rtLCc1R65yoNXuhpcZwCpkPaFr9QfICVj6rcfgOOP3M=";
    };
  });
in
buildPythonPackage rec {
  pname = "okta";
  version = "2.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mOKVCRp8cLY7p0AVbvphWdB3II6eB6HlN8i1HrVUH+o=";
  };

  propagatedBuildInputs = [
    aenum_fixed
    aiohttp
    flatdict
    pycryptodome
    pycryptodomex
    pydash
    python-jose
    pyyaml
    xmltodict
    yarl
  ];

  checkInputs = [
    pyfakefs
    pytest-asyncio
    pytest-mock
    pytest-recording
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    "test_client_raise_exception"
  ];

  pythonImportsCheck = [
    "okta"
    "okta.cache"
    "okta.client"
    "okta.exceptions"
    "okta.http_client"
    "okta.models"
    "okta.request_executor"
  ];

  meta = with lib; {
    description = "Python SDK for the Okta Management API";
    homepage = "https://github.com/okta/okta-sdk-python";
    changelog = "https://github.com/okta/okta-sdk-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jbgosselin ];
  };
}
