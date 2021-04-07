{ mkXfceDerivation, libXtst, libxfce4ui, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-clipman-plugin";
  version = "1.6.1";
  sha256 = "03akijvry1n1fkziyvxwcksl4vy4lmnpgd5izjs8jai5sndhsszl";

  buildInputs = [ libXtst libxfce4ui xfce4-panel xfconf ];

  postPatch = ''
    # exo-csource has been dropped from exo
    substituteInPlace panel-plugin/Makefile.am --replace exo-csource xdt-csource
  '';

  meta = {
    description = "Clipboard manager for Xfce panel";
  };
}
