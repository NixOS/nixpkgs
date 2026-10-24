{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  libclang,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uutils-awk";
  version = "0-unstable-2026-10-17";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "awk";
    rev = "25b1a861ca0a5216970eac1b4b06d99695ae0832";
    hash = "sha256-sqnxWagEmJOHsOin7vogmeZodrDEJQm2AdJp3hj1e7g=";
  };

  cargoHash = "sha256-Xj8em9oZA/noylNrm9HZdtU814+PLdCZx/cJ8MmLK3A=";

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
