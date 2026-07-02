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

buildPythonPackage rec {
  pname = "py-sr25519-bindings";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JAMdotTech";
    repo = "py-sr25519";
    tag = "v${version}";
    hash = "sha256-lia0hA3EayeJN4hf1dE5ezuitknIIQirnWwVjGtdMoo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-+6uutjGp+JzJ4cFZYdWUBLSKXvt6doW1oZkhnMhW9J0=";
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
    changelog = "https://github.com/JAMdotTech/py-sr25519/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      onny
      stargate01
    ];
  };
}
