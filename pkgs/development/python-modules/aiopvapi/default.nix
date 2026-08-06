{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopvapi";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sander76";
    repo = "aio-powerview-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pIi6A0YZnkFFg2juThPIO2IymzWZokTnyZl0QNUKstg=";
  };

  postPatch = ''
    substituteInPlace aiopvapi/__version__.py \
      --replace-fail "3.3.0" "${finalAttrs.version}"
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopvapi" ];

  meta = {
    description = "Python API for the PowerView API";
    homepage = "https://github.com/sander76/aio-powerview-api";
    changelog = "https://github.com/sander76/aio-powerview-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
