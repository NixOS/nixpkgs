{ mkXfceDerivation, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.16.0";

  sha256 = "w8wnHFj1KBX6lCnGbVLgWPEo2ul4SwfemUYVHioTlwE=";

  buildInputs = [ libxfce4util ];

  meta = {
    description = "Simple client-server configuration storage and query system for Xfce";
  };
}
