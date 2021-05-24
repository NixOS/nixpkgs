{ mkXfceDerivation, libXtst, libxfce4ui, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.2";
  sha256 = "0pm4pzq3imc0m09mg0zk6kwcn5yzdgiqgdbpws01q3xz58jmb4a6";

  buildInputs = [ libXtst libxfce4ui xfce4-panel xfconf ];

  meta = {
    description = "Clipboard manager for Xfce panel";
  };
}
