{
  lib,
  stdenv,
  aiomisc,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "caio";
  version = "0.9.21";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "caio";
    tag = version;
    hash = "sha256-WP4LfC0VCpR5HiMmxPSeZbcCbTbSpmwEjEGdDptuOQY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    aiomisc
    pytest-aiohttp
    pytestCheckHook
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
