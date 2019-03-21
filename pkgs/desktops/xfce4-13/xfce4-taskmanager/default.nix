{ lib, mkXfceDerivation, exo, gtk2, gtk3 ? null, libwnck3 ? null, libXmu }:

let
  inherit (lib) enableFeature;
in

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.2.1";

  sha256 = "1p0496r1fb5zqvn6c41kb6rjqwlqghqahgg6hkzw0gjy911im99w";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk2 gtk3 libwnck3 libXmu ];

  configureFlags = [ (enableFeature (gtk3 != null) "gtk3") ];
}
