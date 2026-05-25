{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
let
  version = "0.25.2";
in
rustPlatform.buildRustPackage {
  pname = "yek";
  version = version;

  src = fetchFromGitHub {
    owner = "bodo-run";
    repo = "yek";
    tag = "v${version}";
    hash = "sha256-2gt/leOEhdvj5IXp0Kl3ooUk8eclsMkt6JCIvPsKhMI=";
  };

  cargoHash = "sha256-gjDcw8mMZgoy7kjXlBYHhOgYXOV+XoMgflkZoggz42Q=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = 1;

  # Tests using git fail
  # Skipping individual checks causes failure as `--skip` flags
  # end up passed to executable
  # > error: unexpected argument '--skip' found
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "Serialize text files for LLM consumption";
    longDescription = ''
      Tool to read text-based files, chunk them, and serialize them for LLM consumption.
    '';
    homepage = "https://github.com/bodo-run/yek";
    changelog = "https://github.com/bodo-run/yek/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "yek";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
}
