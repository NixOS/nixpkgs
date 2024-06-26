{
  lib,
  mkXfceDerivation,
  docbook_xsl,
  exo,
  gtk3,
  libburn,
  libisofs,
  libxfce4ui,
  libxslt,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfburn";
  version = "0.7.0";
  odd-unstable = false;

  sha256 = "sha256-/CuV2tqja5fa2H2mmU9BP6tZHoCZZML5d2LL/CG3rno=";

  nativeBuildInputs = [
    libxslt
    docbook_xsl
  ];
  buildInputs = [
    exo
    gtk3
    libburn
    libisofs
    libxfce4ui
  ];

  meta = with lib; {
    description = "Disc burner and project creator for Xfce";
    mainProgram = "xfburn";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
