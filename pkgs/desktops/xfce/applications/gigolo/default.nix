{ lib, mkXfceDerivation, gtk3, glib }:

mkXfceDerivation {
  category = "apps";
  pname = "gigolo";
  version = "0.5.3";
  odd-unstable = false;

  sha256 = "sha256-dxaFuKbSqhj/l5JV31cI+XzgdghfbcVwVtwmRiZeff8=";

  buildInputs = [ gtk3 glib ];

  meta = with lib; {
    description = "A frontend to easily manage connections to remote filesystems";
    mainProgram = "gigolo";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
