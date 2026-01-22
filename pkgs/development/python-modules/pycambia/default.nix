{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  pkg-config,
  pytestCheckHook,
  rustPlatform,
}:
let
  cargoLockPatch = (
    fetchpatch {
      name = "cargo.lock.patch";
      url = "https://github.com/KyokoMiki/pycambia/commit/00446e13c20a461c323b119e16f3f57489ba662d.patch";
      hash = "sha256-N7F67VRxfndoN8NllmGKEePOh3mgbjlNaToUvxh+IrE=";
    }
  );
in
buildPythonPackage rec {
  pname = "pycambia";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyokoMiki";
    repo = "pycambia";
    tag = version;
    hash = "sha256-ZflLy6Qa4tBlPZkTya3ELu463qcnRcMS57a6FfHpSNE=";
  };

  patches = [ cargoLockPatch ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-jmdf+Idg9PR4jgZ7bexPsAyGj86vGxLseTWXnhzP7+E=";
    patches = [ cargoLockPatch ];
  };

  buildInputs = [ openssl ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cambia" ];

  meta = {
    description = "Python wrapper for compact disc ripper log checking utility cambia";
    homepage = "https://github.com/KyokoMiki/pycambia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ undefined-landmark ];
  };
}
