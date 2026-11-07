{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  flask,
  httpcore,
  httpx,
  httpx2,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  starlette,
  trio,
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = "respx";
    tag = version;
    hash = "sha256-Fz3CS9rIm+H6axVIRErlFTTDgtAcTmGj4/wabLxDV2I=";
  };

  patches = [
    # prerequisite for the next patch
    (fetchpatch {
      url = "https://github.com/lundberg/respx/commit/06091fa7a48a4bbd9c060b16e5d82b0f4f20929c.patch";
      hash = "sha256-lcZSuoJ7CmVJAklfg6wyjQbmz3mAcSqmk7isGqZcswY=";
    })
    # https://github.com/lundberg/respx/pull/317
    ./httpx2-support.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    httpcore
    httpx2
    flask
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    starlette
    trio
  ];

  disabledTests = [ "test_pass_through" ];

  pythonImportsCheck = [ "respx" ];

  meta = {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    changelog = "https://github.com/lundberg/respx/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
