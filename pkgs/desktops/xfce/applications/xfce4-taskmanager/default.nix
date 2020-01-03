{ lib, mkXfceDerivation, exo, gtk3, libwnck3, libXmu }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.2.2";

  sha256 = "03js0pmhrybxa7hrp3gx4rm7j061ansv0bp2dwhnbrdpmzjysysc";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 libwnck3 libXmu ];

  meta = {
    description = "Easy to use task manager for Xfce";
  };
}
