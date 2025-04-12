{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "uesave";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "trumank";
    repo = "uesave-rs";
    rev = "v${version}";
    hash = "sha256-9gOOSLejVfR1KJMhcNuKDkuTOvPC6sNG8xQOZlt8NxI=";
  };

  cargoHash = "sha256-U6RzSS2j6FK70OHlmWmHZZYT3UB0+Hi+uLofLy+XtGQ=";

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
