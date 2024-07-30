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
  yarl,
}:

buildPythonPackage rec {
  pname = "omnikinverter";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-omnikinverter";
    rev = "refs/tags/v${version}";
    hash = "sha256-W9VeRhsCXLLgOgvJcNNCGNmPvakPtKHAtwQAGtYJbcY=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
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
  ];

  pythonImportsCheck = [ "omnikinverter" ];

  meta = with lib; {
    description = "Python module for the Omnik Inverter";
    homepage = "https://github.com/klaasnicolaas/python-omnikinverter";
    changelog = "https://github.com/klaasnicolaas/python-omnikinverter/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
