{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "uesave";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "trumank";
    repo = "uesave-rs";
    rev = "v${version}";
    hash = "sha256-cwkeuHmtIS8zTxTSa1qLtWfN2OZinqKngMEYvrCCAk0=";
  };

  cargoHash = "sha256-QGhaaBvxKYnljrkCCcFZLALppvM15c8Xtn36SecaNJ8=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Reading and writing Unreal Engine save files (commonly referred to as GVAS)";
    homepage = "https://github.com/trumank/uesave-rs";
    license = lib.licenses.mit;
    mainProgram = "uesave";
  };
}
