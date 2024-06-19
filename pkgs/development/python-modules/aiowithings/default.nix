{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiowithings";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-withings";
    rev = "refs/tags/v${version}";
    hash = "sha256-Crc+OpkkRKHgrszXNuV2Q83IusOXt9y4IVTSz/w7l/Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aiowithings" ];

  meta = with lib; {
    description = "Module to interact with Withings";
    homepage = "https://github.com/joostlek/python-withings";
    changelog = "https://github.com/joostlek/python-withings/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
