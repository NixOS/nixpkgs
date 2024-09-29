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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "FabioGNR";
    repo = "pyytlounge";
    rev = "v${version}";
    hash = "sha256-0QPa3EzOBv5fuw3FGgmoN4KiC4KHo1Z+Svjcneoe0pc=";
  };

  pyproject = true;

  doCheck = true;

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
