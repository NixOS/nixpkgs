{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioweenect";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "aioweenect";
    tag = "v${version}";
    hash = "sha256-2qTjRXQdTExqY5/ckB6UrkmavzjZK/agfL9+o6fXS0M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--asyncio-mode=auto" ""
  '';

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aioweenect" ];

  meta = {
    description = "Library for the weenect API";
    homepage = "https://github.com/eifinger/aioweenect";
    changelog = "https://github.com/eifinger/aioweenect/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
