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
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FabioGNR";
    repo = "pyytlounge";
    tag = "v${version}";
    hash = "sha256-ZK52xh6IGhINQMakfjG759earUgvNoTNeBcUlFBSALo=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest
    pytestCheckHook
    pytest-mock
    pytest-asyncio
  ];

  meta = with lib; {
    description = "Python YouTube Lounge API";
    homepage = "https://github.com/FabioGNR/pyytlounge";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.lukegb ];
  };
}
