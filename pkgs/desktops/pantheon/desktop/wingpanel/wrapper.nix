{ lib, makeWrapper, symlinkJoin, wingpanel, wingpanelIndicators, switchboard-with-plugs, indicators ? null }:

let
  selectedIndicators = if indicators == null then wingpanelIndicators else indicators;
in
symlinkJoin {
  name = "${wingpanel.name}-with-indicators";

  paths = [ wingpanel ] ++ selectedIndicators;

  buildInputs = [ makeWrapper ];

  # We have to set SWITCHBOARD_PLUGS_PATH because wingpanel-applications-menu
  # has a plugin to search switchboard settings
  postBuild = ''
    wrapProgram $out/bin/wingpanel \
      --set WINGPANEL_INDICATORS_PATH "$out/lib/wingpanel" \
      --set SWITCHBOARD_PLUGS_PATH "${switchboard-with-plugs}/lib/switchboard" \
      --suffix XDG_DATA_DIRS : ${lib.concatMapStringsSep ":" (indicator: ''${indicator}/share/gsettings-schemas/${indicator.name}'') selectedIndicators}
  '';

  inherit (wingpanel) meta;
}
