{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "primp";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "primp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yzN/UMsHd3w5l8pqxExAlJhoudxCl9xinYk4+s3qEAo=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  buildAndTestSubdir = "crates/primp-python";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];
  disabledTestPaths = [ "crates/primp-python/tests/test_impersonate.py" ];
  doCheck = true;

  pythonImportsCheck = [ "primp" ];

  meta = {
    changelog = "https://github.com/deedy5/primp/releases/tag/${finalAttrs.src.tag}";
    description = " HTTP client that can impersonate web browsers";
    homepage = "https://github.com/deedy5/primp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
