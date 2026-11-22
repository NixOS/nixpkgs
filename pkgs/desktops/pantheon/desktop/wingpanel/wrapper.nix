{
  lib,
  wrapGAppsHook3,
  glib,
  stdenv,
  lndir,
  wingpanel,
  wingpanelIndicators,
  switchboard-with-plugs,
  indicators ? null,
  # Only useful to disable for development testing.
  useDefaultIndicators ? true,
}:

let
  selectedIndicators =
    if indicators == null then
      wingpanelIndicators
    else
      indicators ++ (lib.optionals useDefaultIndicators wingpanelIndicators);
in
stdenv.mkDerivation {
  pname = "${wingpanel.pname}-with-indicators";
  inherit (wingpanel) version;

  src = null;

  paths = [
    wingpanel
  ]
  ++ selectedIndicators;

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  buildInputs = lib.concatMap (x: x.buildInputs) selectedIndicators ++ selectedIndicators;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    mkdir -p $out
    for i in "''${paths[@]}"; do
      ${lndir}/bin/lndir -silent $i $out
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set WINGPANEL_INDICATORS_PATH "$out/lib/wingpanel"
      --set SWITCHBOARD_PLUGS_PATH "${switchboard-with-plugs}/lib/switchboard-3"
    )
  '';

  __structuredAttrs = true;

  inherit (wingpanel) meta;
}
