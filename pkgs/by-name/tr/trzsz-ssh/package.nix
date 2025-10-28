{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "trzsz-ssh";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-ssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cp5XI7ggpt48llojcmarYPi9mTM+YBqwjG/eNAnKTxc=";
  };

  vendorHash = "sha256-pI9BlttS9a1XrgBBmUd+h529fLbsbwSMwjKn4P50liE=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SSH client designed as a drop-in replacement for the openssh client";
    homepage = "https://github.com/trzsz/trzsz-ssh";
    changelog = "https://github.com/trzsz/trzsz-ssh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wineee ];
    mainProgram = "trzsz-ssh";
  };
})
