{ mkXfceDerivation, exo, gtk3 }:

mkXfceDerivation rec {
  category = "apps";
  pname = "gigolo";
  version = "0.4.91";

  sha256 = "1r075hw1jxbpv7jxzyqgfmd2rsw1lykd7snnx736gm55v84k15i7";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 ];
}
