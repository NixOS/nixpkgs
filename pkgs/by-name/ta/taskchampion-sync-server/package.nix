{
  fetchFromGitHub,
  lib,
  openssl,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "taskchampion-sync-server";
  version = "0.7.1";
  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskchampion-sync-server";
    tag = "v${version}";
    hash = "sha256-ywBmVid70ZKUkTwxORrwXPV0zur0RdHToTLTx9ynjqU=";
  };

  cargoHash = "sha256-1bqZAFKQGTCGUs7EXLwAgUxQU+KmhVGFIATIOb5uOlA=";

  env = {
    # Use system openssl.
    OPENSSL_DIR = lib.getDev openssl;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  meta = {
    description = "Sync server for Taskwarrior 3";
    license = lib.licenses.mit;
    homepage = "https://github.com/GothenburgBitFactory/taskchampion-sync-server";
    maintainers = with lib.maintainers; [ mlaradji ];
    mainProgram = "taskchampion-sync-server";
  };
}
