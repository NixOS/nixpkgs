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
  version = "0.9.17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "caio";
    rev = "refs/tags/${version}";
    hash = "sha256-aTJ02dCLb3CsT6KmJxkmOzwtg5nuXeBwz+mT7ZTTU9o=";
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
