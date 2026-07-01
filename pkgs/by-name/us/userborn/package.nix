{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libxcrypt,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "userborn";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "userborn";
    rev = finalAttrs.version;
    hash = "sha256-mXXakR75Iz6AFf/TYgIHE8SxOri2HyReYUYTT3lCEPA=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust/userborn";

  cargoHash = "sha256-uAid5GsM9lasVQAYfeo9jwp4xg1MrXdJqtD0l6ME6OQ=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = [ libxcrypt ];

  stripAllList = [ "bin" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests)
        userborn
        userborn-mutable-users
        userborn-mutable-etc
        userborn-immutable-users
        userborn-immutable-etc
        userborn-static
        ;
    };
  };

  meta = {
    homepage = "https://github.com/nikstur/userborn";
    description = "Declaratively bear (manage) Linux users and groups";
    changelog = "https://github.com/nikstur/userborn/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "userborn";
  };
})
