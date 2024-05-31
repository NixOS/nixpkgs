{ lib
, stdenv
, glib
, xorg
, wrapGAppsHook3
, budgie-desktop
, plugins ? [ ]
}:

stdenv.mkDerivation {
  pname = "${budgie-desktop.pname}-with-plugins";
  inherit (budgie-desktop) version;

  src = null;

  paths = [
    budgie-desktop
  ] ++ plugins;

  passAsFile = [ "paths" ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  buildInputs = lib.forEach plugins (plugin: plugin.buildInputs) ++ plugins;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    mkdir -p $out
    for i in $(cat $pathsPath); do
      ${xorg.lndir}/bin/lndir -silent $i $out
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set BUDGIE_PLUGIN_LIBDIR "$out/lib/budgie-desktop/plugins"
      --set BUDGIE_PLUGIN_DATADIR "$out/share/budgie-desktop/plugins"
      --set RAVEN_PLUGIN_LIBDIR "$out/lib/budgie-desktop/raven-plugins"
      --set RAVEN_PLUGIN_DATADIR "$out/share/budgie-desktop/raven-plugins"
    )
  '';

  inherit (budgie-desktop) meta;
}
