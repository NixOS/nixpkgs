{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "zennotes";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/v${version}/ZenNotes-${version}-linux-x86_64.AppImage";
    hash = "sha256-IvFGK7n3KQVGETmt6hQUy+bZNTOCkfuwH8ifl4KTxxw=";
  };

  appimage-opts = {
    inherit pname version src;
    extraPkgs = pkgs: [ ];

    __structuredAttrs = true;
  };

in
(appimageTools.wrapType2 appimage-opts).overrideAttrs (old: {
  strictDeps = true;

  meta = with lib; {
    description = "Keyboard-first local Markdown notes with Vim motions, diagrams, and MCP integration";
    homepage = "https://github.com/ZenNotes/zennotes";
    license = licenses.mit;
    maintainers = with maintainers; [ voidwalter ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "zennotes";
  };
})
