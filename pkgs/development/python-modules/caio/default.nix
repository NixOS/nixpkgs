{
  lib,
  stdenv,
  aiomisc,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-asyncio_0,
  pytest8_3CheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "caio";
  version = "0.9.22";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "caio";
    tag = version;
    hash = "sha256-O86SLZ+8bzPYtvLnmY5gLPYLWvNaktQwIEQckJR15LI=";
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

  meta = with lib; {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    changelog = "https://github.com/mosquito/caio/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
