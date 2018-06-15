{ lib, mkXfceDerivation, exo, gtk2, gtk3 ? null, libwnck3 ? null, libXmu }:

let
  inherit (lib) enableFeature;
in

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.2.0";

  sha256 = "1lx66lhzfzhysymcbzfq9nrafyfmwdb79lli9kvhz6m12dhz6j18";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk2 gtk3 libwnck3 libXmu ];

  configureFlags = [ (enableFeature (gtk3 != null) "gtk3") ];
}
