{
  lib,
  aiohttp,
  aresponses,
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
  pname = "aiowaqi";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-waqi";
    rev = "refs/tags/v${version}";
    hash = "sha256-+4l820FGQI66GGr+KGEeDmPUFwRrMNvYFJuSouesakY=";
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
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aiowaqi" ];

  disabledTests = [
    # Upstream mocking fails
    "test_search"
  ];

  pytestFlagsArray = [ "--snapshot-update" ];

  meta = with lib; {
    description = "Module to interact with the WAQI API";
    homepage = "https://github.com/joostlek/python-waqi";
    changelog = "https://github.com/joostlek/python-waqi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
