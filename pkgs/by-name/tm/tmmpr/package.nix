{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmmpr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tanciaku";
    repo = "tmmpr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gSartX+6CWmgIi9RX79e0fvimjJ5SfbR6LMLuBVvrqk=";
  };

  cargoHash = "sha256-09aBwiQigV2AslT2uH7muL/ClJUZpzoAjbcmnVala6s=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal mind mapper";
    longDescription = ''
      tmmpr is a Linux terminal application that lets you create,
      organize, and connect notes on an infinite canvas.  Think of it
      as a digital whiteboard in your terminal where you can freely
      place notes anywhere and draw connections between them.

      The application is entirely keyboard-driven, offering efficient
      navigation and control through vim-inspired keybindings.
      Perfect for brainstorming, project planning, or organizing
      complex ideas.
    '';
    homepage = "https://github.com/tanciaku/tmmpr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tmmpr";
  };
})
