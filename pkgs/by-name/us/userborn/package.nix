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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "userborn";
    rev = version;
    hash = "sha256-Zh2u7we/MAIM7varuJA4AmEWeSMuA/C+0NSIUJN7zTs=";
  };

  sourceRoot = "${src.name}/rust/userborn";

  cargoHash = "sha256-oLw/I8PEv75tz+KxbIJrwl8Wr0I/RzDh1SDZ6mRQpL8=";

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

  meta = {
    homepage = "https://github.com/nikstur/userborn";
    description = "Declaratively bear (manage) Linux users and groups";
    changelog = "https://github.com/nikstur/userborn/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "userborn";
  };
}
