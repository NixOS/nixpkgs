{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, cython_3
, setuptools

# dependencies
, async-timeout
, chacha20poly1305-reuseable
, noiseprotocol
, protobuf
, zeroconf

# tests
, mock
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
  version = "18.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hIwVnslBxWMjWxj1NN8If4MQn2jpFYyjmAVykQeY0hc=";
  };

  nativeBuildInputs = [
    setuptools
    cython_3
  ];

  propagatedBuildInputs = [
    chacha20poly1305-reuseable
    noiseprotocol
    protobuf
    zeroconf
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  pythonImportsCheck = [
    "aioesphomeapi"
  ];
  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/esphome/aioesphomeapi/releases/tag/v${version}";
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab hexa ];
  };
}
