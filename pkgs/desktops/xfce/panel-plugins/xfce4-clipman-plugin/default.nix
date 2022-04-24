{ lib, mkXfceDerivation, libXtst, libxfce4ui, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.2";
  sha256 = "sha256-RpFVJSq/DxyA5ne1h+Nr3xfL+DTzg1cTqIDVOPC/pF4=";

  buildInputs = [ libXtst libxfce4ui xfce4-panel xfconf ];

  meta = with lib; {
    description = "Clipboard manager for Xfce panel";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
