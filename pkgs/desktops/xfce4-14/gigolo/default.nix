{ mkXfceDerivation, exo, gtk3, gvfs, glib }:

mkXfceDerivation rec {
  category = "apps";
  pname = "gigolo";
  version = "0.5.0";

  sha256 = "1lqsxb0d5i8p9vbzx8s4p3rga7va5h1q146xgmsa41j5v40wrlw6";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 glib gvfs ];
}
