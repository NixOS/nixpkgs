{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vimalender";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Sadoaz";
    repo = "vimalender";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6gg0M7zVe+b00ECstvetYBQfAF3SoS9H7cNrGJSU/bQ=";
  };

  vendorHash = "sha256-uwBJAqN4sIepiiJf9lCDumLqfKJEowQO2tOiSWD3Fig=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal calendar with vim keybindings";
    homepage = "https://github.com/Sadoaz/vimalender";
    changelog = "https://github.com/Sadoaz/vimalender/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "vimalender";
    maintainers = with lib.maintainers; [ sand4rt ];
  };
})
