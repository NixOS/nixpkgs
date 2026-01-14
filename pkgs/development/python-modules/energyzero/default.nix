{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezer,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "energyzero";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-energyzero";
    tag = "v${version}";
    hash = "sha256-gX8clg0xqIhk8/RYV6P5exnzXPLmYLGUX65Y0Nwt2F8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"0.0.0"' '"${version}"'
  '';

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-freezer
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "energyzero" ];

  meta = {
    description = "Module for getting the dynamic prices from EnergyZero";
    homepage = "https://github.com/klaasnicolaas/python-energyzero";
    changelog = "https://github.com/klaasnicolaas/python-energyzero/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
