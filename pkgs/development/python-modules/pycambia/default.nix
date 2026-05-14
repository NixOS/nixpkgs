{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openssl,
  pkg-config,
  pytestCheckHook,
  rustPlatform,
}:
buildPythonPackage (finalAttrs: {
  pname = "pycambia";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyokoMiki";
    repo = "pycambia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5UHWAIR+qo16UUsi9D0e6W8UmQ4HUujNWLfJpyIrCUI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-w7n/W7PDC3+DPCb//X462mowhEPw0k3HA1raAeu4t/c=";
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
})
