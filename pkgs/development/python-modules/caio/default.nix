{
  lib,
  stdenv,
  aiomisc-pytest,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "caio";
  version = "0.9.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "caio";
    tag = finalAttrs.version;
    hash = "sha256-uKQJWGYtBdpcfFD6yDKjIz0H0FEq4dmCP50sbVGYRGU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    aiomisc-pytest
    pytestCheckHook
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [ "-Wno-error=implicit-function-declaration" ]
  );

  pythonImportsCheck = [ "caio" ];

  meta = {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    changelog = "https://github.com/mosquito/caio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
