{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "cemm";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-cemm";
    tag = "v${version}";
    hash = "sha256-BorgGHxoEeIGyJKqe9mFRDpcGHhi6/8IV7ubEI8yQE4=";
  };

  patches = [
    # https://github.com/klaasnicolaas/python-cemm/pull/360
    (fetchpatch {
      name = "remove-setuptools-dependency.patch";
      url = "https://github.com/klaasnicolaas/python-cemm/commit/1e373dac078f18563264e6733baf6a93962cac4b.patch";
      hash = "sha256-DVNn4BZwi8yNpKFmzt7YSYhzzB4vaAyrd/My8TtYzj0=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"0.0.0"' '"${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cemm" ];

  meta = with lib; {
    description = "Module for interacting with CEMM devices";
    homepage = "https://github.com/klaasnicolaas/python-cemm";
    changelog = "https://github.com/klaasnicolaas/python-cemm/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
