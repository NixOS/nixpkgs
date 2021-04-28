{ lib, mkXfceDerivation, gtk3, glib }:

mkXfceDerivation {
  category = "apps";
  pname = "gigolo";
  version = "0.5.2";
  odd-unstable = false;

  sha256 = "8UDb4H3zxRKx2y+MRsozQoR3es0fs5ooR/5wBIE11bY=";

  buildInputs = [ gtk3 glib ];

  postPatch = ''
    # exo-csource has been dropped from exo
    substituteInPlace src/Makefile.am --replace exo-csource xdt-csource
  '';

  meta = {
    description = "A frontend to easily manage connections to remote filesystems";
    license = with lib.licenses; [ gpl2Only ];
  };
}
