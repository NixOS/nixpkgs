{ wrapGAppsHook
, glib
, lib
, stdenv
, xorg
, switchboard
, switchboardPlugs
, plugs
  # Only useful to disable for development testing.
, useDefaultPlugs ? true
}:

let
  selectedPlugs =
    if plugs == null then switchboardPlugs
    else plugs ++ (lib.optionals useDefaultPlugs switchboardPlugs);
in
stdenv.mkDerivation rec {
  name = "${switchboard.name}-with-plugs";

  src = null;

  paths = [
    switchboard
  ] ++ selectedPlugs;

  passAsFile = [ "paths" ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook
  ];

  buildInputs = lib.forEach selectedPlugs (x: x.buildInputs)
    ++ selectedPlugs;

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
      --set SWITCHBOARD_PLUGS_PATH "$out/lib/switchboard"
    )
  '';

  inherit (switchboard) meta;
}

