{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "witx-codegen";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "witx-codegen";
    tag = finalAttrs.version;
    hash = "sha256-/Zi7iQ2NSy0eGLyAQBp/PiKQEAp33OSW9MkXawQuLMA=";
  };

  # Upstream does not provide a Cargo.lock file
  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WITX code and documentation generator for AssemblyScript, Zig, Rust and more";
    homepage = "https://github.com/jedisct1/witx-codegen";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zebreus ];
    mainProgram = "witx-codegen";
    platforms = lib.platforms.all;
  };
})
