{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uesave";
  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "trumank";
    repo = "uesave-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wn7/Ik8F3+gA66CpGZGwUer3zArCx7fx1IS6DGvqJDI=";
  };

  cargoHash = "sha256-Ccggso8rD6qxe3W3ztzcdJINSqVF5HU9BKZiO8tM+wo=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Reading and writing Unreal Engine save files (commonly referred to as GVAS)";
    homepage = "https://github.com/trumank/uesave-rs";
    license = lib.licenses.mit;
    mainProgram = "uesave";
  };
})
