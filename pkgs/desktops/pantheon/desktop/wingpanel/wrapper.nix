{ lib
, wrapGAppsHook
, glib
, symlinkJoin
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
symlinkJoin {
  name = "${wingpanel.name}-with-indicators";

  paths = [
    wingpanel
  ] ++ selectedIndicators;

  buildInputs = [
    glib
    wrapGAppsHook
  ] ++ (lib.forEach selectedIndicators (x: x.buildInputs))
    ++ selectedIndicators;

  # We have to set SWITCHBOARD_PLUGS_PATH because wingpanel-applications-menu
  # has a plugin to search switchboard settings
  postBuild = ''
    make_glib_find_gsettings_schemas

    gappsWrapperArgs+=(
      --set WINGPANEL_INDICATORS_PATH "$out/lib/wingpanel"
      --set SWITCHBOARD_PLUGS_PATH "${switchboard-with-plugs}/lib/switchboard"
    )

    wrapGAppsHook
  '';

  inherit (wingpanel) meta;
}
