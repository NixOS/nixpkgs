{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libxcrypt,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "userborn";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "userborn";
    rev = version;
    hash = "sha256-ABePye1zuGDH74BL6AP05rR9eBOYu1SoVpd2TcZQMW8=";
  };

  sourceRoot = "${src.name}/rust/userborn";

  cargoHash = "sha256-/S2rkZyXHN5NiW9TFhKguqtf/udFcDOTfV2jYRMV14s=";

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
        ;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/nikstur/userborn";
    description = "Declaratively bear (manage) Linux users and groups";
    changelog = "https://github.com/nikstur/userborn/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "userborn";
  };
}
