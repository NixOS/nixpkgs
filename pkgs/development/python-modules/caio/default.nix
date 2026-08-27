{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  aiomisc-pytest,
  pytest-rerunfailures,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "caio";
  version = "0.12.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "caio";
    tag = finalAttrs.version;
    hash = "sha256-caPSeggL9qjxkYCwl2/qEhXfH/tpJyGCK22U8+31dy0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'version = "0.10.2"' \
        'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [ "-Wno-error=implicit-function-declaration" ]
  );

  pythonImportsCheck = [ "caio" ];

  nativeCheckInputs = [
    aiomisc-pytest
    pytest-rerunfailures
    pytestCheckHook
  ];

  meta = {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    changelog = "https://github.com/mosquito/caio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
