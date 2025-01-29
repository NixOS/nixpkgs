{
  lib,
  mkXfceDerivation,
  gtk3,
  glib,
}:

mkXfceDerivation {
  category = "apps";
  pname = "gigolo";
  version = "0.5.4";
  odd-unstable = false;

  sha256 = "sha256-gRv1ZQLgwwzFERnco2Dm2PkT/BNDIZU6fX+HdhiRCJk=";

  buildInputs = [
    gtk3
    glib
  ];

  meta = with lib; {
    description = "Frontend to easily manage connections to remote filesystems";
    mainProgram = "gigolo";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
