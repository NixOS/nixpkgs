{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  perl,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "text-embeddings-inference";
  version = "1.9.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "text-embeddings-inference";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WlgGNmp5CCQjpgaiMCzOEH3xJQiroco6/Ilx57d+qZs=";
  };

  # Build only the server binary. Scoping with -p avoids compiling the
  # python/ort/grpc-client backends (which need Python / extra native deps).
  # Workspace default features ["candle","http","dynamic-linking"] build the
  # pure-CPU candle backend; "dynamic-linking" is a no-op (cudarc/mkl optional).
  cargoHash = "sha256-mQcNRmhto6825ZtpcHF0rz2GLthytXa447ZXlUIRYiE=";
  cargoBuildFlags = [
    "-p"
    "text-embeddings-router"
  ];

  # perl drives AWS-LC's cmake build; cmake + pkg-config build aws-lc-sys
  # (reqwest rustls) and openssl-sys (reqwest native-tls).
  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];

  buildInputs = [ openssl ];

  # onig_sys 6.9.8 (tokenizers) vendors oniguruma whose K&R-style `ANYARGS`
  # macro expands to `()`. Under GCC 15's default (C23) `()` means `(void)`,
  # so the macro's call sites fail as "too many arguments" hard errors; use the
  # pre-C23 semantics where `()` is an unspecified (K&R) prototype.
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  postPatch = ''
    # metrics 0.23.0 stores a borrowed trait object in a thread-local via a raw
    # pointer cast; Rust >=1.9x rejects the lifetime-extending cast
    # (rust-lang/rust#141402). transmute bypasses that check without changing
    # soundness (the guard clears the pointer before the reference is gone).
    patch -p1 -d "$cargoDepsCopy"/*/metrics-0.23.0 < ${./metrics-141402.patch}
  '';

  doCheck = false; # tests download models from the Hugging Face Hub (network)

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Inference server for embedding, reranking, and sequence classification models";
    homepage = "https://github.com/huggingface/text-embeddings-inference";
    changelog = "https://github.com/huggingface/text-embeddings-inference/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.gdifolco ];
    platforms = lib.platforms.linux;
    mainProgram = "text-embeddings-router";
  };
})
