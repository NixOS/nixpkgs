{ lib
, wrapGAppsHook
, glib
, stdenv
, xorg
, wingpanel
, wingpanelIndicators
, switchboard-with-plugs
, indicators ? null
  # Only useful to disable for development testing.
, useDefaultIndicators ? true
}:

let
  selectedIndicators =
    if indicators == null then wingpanelIndicators
    else indicators ++ (lib.optionals useDefaultIndicators wingpanelIndicators);
in
stdenv.mkDerivation rec {
  pname = "${wingpanel.pname}-with-indicators";
  inherit (wingpanel) version;

  src = null;

  paths = [
    wingpanel
  ] ++ selectedIndicators;

  passAsFile = [ "paths" ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook
  ];

  buildInputs = lib.forEach selectedIndicators (x: x.buildInputs)
    ++ selectedIndicators;

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
      --set WINGPANEL_INDICATORS_PATH "$out/lib/wingpanel"
      --set SWITCHBOARD_PLUGS_PATH "${switchboard-with-plugs}/lib/switchboard"
    )
  '';

  inherit (wingpanel) meta;
}
