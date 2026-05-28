{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "zellij-plugins-updater";
  version = "2026-05-28";

  src = ./default.nix;
  dontUnpack = true;

  buildPhase = ''
    cp $src $out
  '';

  passthru.updateScript = ./update.sh;

  meta.description = "This is an internal hack to trigger @r-ryanthm on Zellij plugins";
}
