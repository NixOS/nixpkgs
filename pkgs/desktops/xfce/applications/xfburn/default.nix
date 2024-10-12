{
  mkXfceDerivation,
  lib,
  docbook_xsl,
  exo,
  gst_all_1,
  gtk3,
  libburn,
  libgudev,
  libisofs,
  libxfce4ui,
  libxslt,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfburn";
  version = "0.7.2";
  odd-unstable = false;

  sha256 = "sha256-eJ+MxNdJiDTLW4GhrwgQIyFuOSTWsF34Oet9HJAtIqI=";

  nativeBuildInputs = [
    libxslt
    docbook_xsl
  ];

  buildInputs = [
    exo
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    libburn
    libgudev
    libisofs
    libxfce4ui
  ];

  meta = with lib; {
    description = "Disc burner and project creator for Xfce";
    mainProgram = "xfburn";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
