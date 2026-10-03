{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  # tansu-client's tests::tcp_client_server binds 127.0.0.1; darwin sandbox blocks it without this.
  __darwinAllowLocalNetworking = true;

  pname = "tansu";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tansu-io";
    repo = "tansu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8mk3PQInvnqLQaChiBFDXjEqu5vWT/RbApQr71/zqFs=";
  };

  cargoHash = "sha256-E1eR9U3Qa4pBtiovflqgMWBoWUP8mCxqT7Fb99yBqvI=";

  buildFeatures = [
    "dynostore"
    "libsql"
    "slatedb"
    "turso"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Drop-in replacement for Apache Kafka";
    homepage = "https://tansu.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jonhermansen ];
    mainProgram = "tansu";
    platforms = lib.platforms.unix;
  };
})
