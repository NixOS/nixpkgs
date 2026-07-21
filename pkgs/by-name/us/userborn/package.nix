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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "userborn";
    tag = finalAttrs.version;
    hash = "sha256-ZVO1Q6iumGVKA/35RYUBV79i9ECqNmjeHXAyjxikUfE=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust/userborn";

  cargoHash = "sha256-UNd4RMM8VbmRbEAr8ZDSbNwG07058jasMP0IqcIk7/E=";

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
