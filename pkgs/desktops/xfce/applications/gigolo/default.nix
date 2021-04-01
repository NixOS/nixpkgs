{ mkXfceDerivation, exo, gtk3, gvfs, glib }:

mkXfceDerivation {
  category = "apps";
  pname = "gigolo";
  version = "0.5.2";
  odd-unstable = false;

  sha256 = "8UDb4H3zxRKx2y+MRsozQoR3es0fs5ooR/5wBIE11bY=";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 glib gvfs ];

  meta = {
    description = "A frontend to easily manage connections to remote filesystems";
  };
}
