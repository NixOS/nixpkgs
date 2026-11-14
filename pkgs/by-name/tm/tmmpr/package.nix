{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmmpr";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tanciaku";
    repo = "tmmpr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-utglXs20gGRWuxp33F+YOxEBc/MN9qBhDeYDt8R74y8=";
  };

  cargoHash = "sha256-HWR9txADPmO5HwRZ/mskYxtUqe7w+1wkSr/cib40A3w=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal mind mapper";
    longDescription = ''
      tmmpr is a terminal application that lets you create, organize,
      and connect notes on an infinite canvas.  Think of it as a
      digital whiteboard in your terminal where you can freely place
      notes anywhere and draw connections between them.

      The application is entirely keyboard-driven, offering efficient
      navigation and control through vim-inspired keybindings.
      Perfect for brainstorming, project planning, or organizing
      complex ideas.
    '';
    homepage = "https://github.com/tanciaku/tmmpr";
    changelog = "https://github.com/tanciaku/tmmpr/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tmmpr";
  };
})
