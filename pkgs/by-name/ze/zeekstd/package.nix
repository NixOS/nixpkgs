{
  fetchFromGitHub,
  jq,
  lib,
  nix-update,
  rustPlatform,
  writeShellScript,
  versionCheckHook,
  zstd,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeekstd";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${finalAttrs.version}-cli";
    hash = "sha256-3kbPu64tj7TlS0ieoVLyronfGo02I5/DbNUBxnin3fA=";
  };

  cargoHash = "sha256-fyqgPFTEyuEj+FZlIwqgfseefbCmAlxzUkoV+QU5S+s=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zstd ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = writeShellScript "update-zeekstd" ''
    latestVersion=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/rorosen/zeekstd/releases/latest | ${lib.getExe jq} --raw-output .tag_name | sed -E 's/^v([0-9.]+)-cli$/\1/')
    ${lib.getExe nix-update} zeekstd --version $latestVersion
  '';

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${finalAttrs.version}-cli";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
})
