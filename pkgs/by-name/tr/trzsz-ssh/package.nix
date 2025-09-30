{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "trzsz-ssh";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-ssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VvPdWRP+lrhho+Bk5rT9pktEvKe01512WoDfAu5d868=";
  };

  vendorHash = "sha256-EllXxDyWI4Dy5E6KnzYFxuYDQcdk9+01v5svpARZU44=";

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
