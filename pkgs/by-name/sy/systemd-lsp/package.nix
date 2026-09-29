{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-lsp";
  version = "2026.08.03";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JFryy";
    repo = "systemd-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yMUUtcSpXn02zbxcljbkzT02DUEJPQBwCopmDxbTmR4=";
  };

  postPatch = ''
    substituteInPlace tests/cli_tests.rs \
      --replace-fail 'target/release' \
                     "target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType"
  '';

  cargoHash = "sha256-2+JTKSzreTmdUiv++WaG8kVV2hXDn6qeY9Cp7n51MP4=";

  doInstallCheck = true;
  # Avoid versionCheckHook because upstream names tags differently from the version.
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/${finalAttrs.meta.mainProgram}" --help
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server implementation for systemd unit files made in Rust";
    homepage = "https://github.com/JFryy/systemd-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "systemd-lsp";
    platforms = with lib.platforms; unix ++ windows;
  };
})
