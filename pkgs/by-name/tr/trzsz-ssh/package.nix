{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "trzsz-ssh";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-ssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mcGsCPW8YHKCm5c+OWlKMp6k+J7ibvd6zN/76Ws5eUE=";
  };

  vendorHash = "sha256-RhmWoULbJZdYYFxLlj+ekca4u8+DQTH3QmZlpnUeZ2Y=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

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
