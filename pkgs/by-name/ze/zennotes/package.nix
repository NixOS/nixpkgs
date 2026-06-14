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
in
appimageTools.wrapType2 {
  inherit pname version src;

  passthru = {
    strictDeps = true;
    __structuredAttrs = true;
  };

  extraInstallCommands = ''
    install -m 444 -D ${
      appimageTools.extract { inherit pname version src; }
    }/ZenNotes.desktop $out/share/applications/zennotes.desktop
    substituteInPlace $out/share/applications/zennotes.desktop \
    --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
    --replace-fail 'Icon=ZenNotes' 'Icon=zennotes'
    install -m 444 -D ${
      appimageTools.extract { inherit pname version src; }
    }/ZenNotes.png $out/share/icons/hicolor/512x512/apps/zennotes.png
  '';
  meta = {
    description = "Keyboard-first, markdow-bsed note-taking app";
    homepage = "https://github.com/ZenNotes/ZenNotes";
    license = lib.licenses.mit;
    mainProgram = "zennotes";
    maintainers = with lib.maintainers; [ farahfinn ];
    platforms = [ "x86_64-linux" ];
  };
}
