{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pytest,
  pytestCheckHook,
  pytest-mock,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyytlounge";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FabioGNR";
    repo = "pyytlounge";
    tag = "v${version}";
    hash = "sha256-61RHCpkn5HLV3P5ZWQBXQOIsC3CdL33wHW1ga7WM4FI=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest
    pytestCheckHook
    pytest-mock
    pytest-asyncio
  ];

  meta = {
    description = "Python YouTube Lounge API";
    homepage = "https://github.com/FabioGNR/pyytlounge";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.lukegb ];
  };
}
