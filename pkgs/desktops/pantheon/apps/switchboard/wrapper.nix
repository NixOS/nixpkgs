{ wrapGAppsHook
, glib
, lib
, symlinkJoin
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
symlinkJoin {
  name = "${switchboard.name}-with-plugs";

  paths = [
    switchboard
  ] ++ selectedPlugs;

  buildInputs = [
    wrapGAppsHook
    glib
  ] ++ (lib.forEach selectedPlugs (x: x.buildInputs))
    ++ selectedPlugs;

  postBuild = ''
    make_glib_find_gsettings_schemas

    gappsWrapperArgs+=(--set SWITCHBOARD_PLUGS_PATH "$out/lib/switchboard")

    wrapGAppsHook
  '';

  inherit (switchboard) meta;
}
