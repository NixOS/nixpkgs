{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, bluetooth-data-tools
, httpx
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioruuvigateway";
  version = "0.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "akx";
    repo = "aioruuvigateway";
    rev = "refs/tags/v${version}";
    hash = "sha256-oT5Tlmi9bevOkcVZqg/xvCckIpN7TjbPVQefo9z1RDM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  meta = with lib; {
    description = "An asyncio-native library for requesting data from a Ruuvi Gateway";
    homepage = "https://github.com/akx/aioruuvigateway";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}


