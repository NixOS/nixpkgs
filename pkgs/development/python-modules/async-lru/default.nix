{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "async-lru";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "async-lru";
    tag = "v${version}";
    hash = "sha256-FJ1q6W9IYs0OSMZc+bI4v22hOAAWAv2OW3BAqixm8Hs=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/aio-libs/async-lru/issues/635
      name = "python314-compatibility.patch";
      url = "https://github.com/aio-libs/async-lru/commit/4df3785d3e5210ce6277b3137c4625cd73918088.patch";
      hash = "sha256-B9KCJPbiZTQJrnxC/7VI+jgr2PKfwOmS7naXZwKtF9c=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
  ];

  pythonImportsCheck = [ "async_lru" ];

  meta = {
    changelog = "https://github.com/aio-libs/async-lru/releases/tag/${src.tag}";
    description = "Simple lru cache for asyncio";
    homepage = "https://github.com/wikibusiness/async_lru";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
