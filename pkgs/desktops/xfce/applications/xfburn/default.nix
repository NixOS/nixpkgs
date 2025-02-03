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
  version = "0.7.1";
  odd-unstable = false;

  sha256 = "sha256-wKJ9O4V1b2SoqC4dDKKLg7u8IK9TcjVEa4ZxQv3UOOI=";

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
