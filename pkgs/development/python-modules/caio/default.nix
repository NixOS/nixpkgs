{
  lib,
  stdenv,
  aiomisc,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-asyncio_0,
  pytest8_3CheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "caio";
  version = "0.9.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "caio";
    tag = version;
    hash = "sha256-uKQJWGYtBdpcfFD6yDKjIz0H0FEq4dmCP50sbVGYRGU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    aiomisc
    (pytest-aiohttp.override { pytest-asyncio = pytest-asyncio_0; })
    pytest8_3CheckHook
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [ "-Wno-error=implicit-function-declaration" ]
  );

  pythonImportsCheck = [ "caio" ];

  meta = {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    changelog = "https://github.com/mosquito/caio/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
