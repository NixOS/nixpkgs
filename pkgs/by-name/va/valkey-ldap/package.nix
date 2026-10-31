{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "valkey-ldap";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey-ldap";
    tag = finalAttrs.version;
    hash = "sha256-+D3Mvm4ZRgv3830tpHTt/Hxga2CuAC+5ZaosF1HSpno=";
  };

  cargoHash = "sha256-HfiMr1un2dKFAdjBTNKRS1fB9Z/iMcJmMkqDyCbDswk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    rustPlatform.bindgenHook
  ];

  # Requires custom memory allocator
  doCheck = false;

  meta = {
    changelog = "https://github.com/valkey-io/valkey-ldap/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Module which brings LDAP authentication fo Valkey";
    homepage = "https://github.com/valkey-io/valkey-ldap";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
