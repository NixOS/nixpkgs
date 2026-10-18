{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  libclang,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-awk";
  version = "0-unstable-2026-11-07";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "awk";
    rev = "39dd36a073d79847a94f53f63e1193709ec5d43e";
    # hash = lib.fakeHash;
    hash = "sha256-aJ+mFTA+UAUOglTFSEECYExiHmZ056DSgivMXkp0AyU=";
  };

  # cargoHash = lib.fakeHash;
  cargoHash = "sha256-sSvn5BDDtgnhvIdnQXDBP7YdxqzAWqsTaslrVa7MZ4w=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=^(?!latest-commit.*)(.*)$"
    ];
  };

  env.LIBCLANG_PATH = "${libclang.lib}/lib";

  buildInputs = [
    libclang.lib
  ];

  # Checks fail to compile in release mode. :(
  checkType = "debug";

  meta = {
    description = "Rust implementation of awk";
    homepage = "https://github.com/uutils/awk";
    license = lib.licenses.mit;
    mainProgram = "awk";
    maintainers = with lib.maintainers; [ kacper-uminski ];
  };
})
