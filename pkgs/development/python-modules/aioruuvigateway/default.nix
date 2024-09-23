{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bluetooth-data-tools,
  httpx,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioruuvigateway";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "akx";
    repo = "aioruuvigateway";
    rev = "refs/tags/v${version}";
    hash = "sha256-Etv+kPFYEK79hpDeNmDfuyNj1vJ6udry1u+TRO5gLV4=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioruuvigateway" ];

  meta = with lib; {
    description = "Asyncio-native library for requesting data from a Ruuvi Gateway";
    homepage = "https://github.com/akx/aioruuvigateway";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
