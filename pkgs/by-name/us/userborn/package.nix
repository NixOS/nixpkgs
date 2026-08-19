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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "userborn";
    tag = finalAttrs.version;
    hash = "sha256-YUJY5Ss29joSkBztf6r7DwSci/hTBYgmN1qkJRfhHAo=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust/userborn";

  cargoHash = "sha256-U9RZQ9MabWJEWzMrsmEoIoEUUkFVT7igUBPalXnFeRU=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = [ libxcrypt ];

  stripAllList = [ "bin" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests)
        userborn
        userborn-migration
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
