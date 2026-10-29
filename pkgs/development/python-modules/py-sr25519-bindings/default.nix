{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  rustPlatform,
  stdenv,
  py-bip39-bindings,
  libiconv,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-sr25519-bindings";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JAMdotTech";
    repo = "py-sr25519";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kCOmmzCCR363J5pYJ99BDUhUWeYniMf+e+NJByRnl+c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3snEx0rpMBRnuWt5WfTWrQkTC9fTsHh6zS4ChaRjVKg=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [
    pytestCheckHook
    py-bip39-bindings
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "sr25519" ];

  meta = {
    description = "Python bindings for sr25519 library";
    homepage = "https://github.com/JAMdotTech/py-sr25519";
    changelog = "https://github.com/JAMdotTech/py-sr25519/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      onny
      stargate01
    ];
  };
})
