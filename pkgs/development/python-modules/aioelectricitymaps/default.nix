{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, mashumaro
, orjson
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, syrupy
}:

buildPythonPackage rec {
  pname = "aioelectricitymaps";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "aioelectricitymaps";
    rev = "refs/tags/v${version}";
    hash = "sha256-saIzVbgYx5nIM5fk7i3wu4X1gOIj81L/rRNq5Xl4cnw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "aioelectricitymaps"
  ];

  meta = with lib; {
    description = "Module for interacting with Electricity maps";
    homepage = "https://github.com/jpbede/aioelectricitymaps";
    changelog = "https://github.com/jpbede/aioelectricitymaps/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
