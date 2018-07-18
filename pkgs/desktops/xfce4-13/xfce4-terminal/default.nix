{ mkXfceDerivation, gtk3, libxfce4ui, vte }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-terminal";
  version = "0.8.7.4";

  sha256 = "1s1dq560icg602jjb2ja58x7hxg4ikp3jrrf74v3qgi0ir950k2y";

  buildInputs = [ gtk3 libxfce4ui vte ];

  meta = {
    description = "A modern terminal emulator";
  };
}
