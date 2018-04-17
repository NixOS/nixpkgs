{ mkXfceDerivation, gtk3, libxfce4ui, vte }:

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-terminal";
  version = "0.8.6";

  sha256 = "1a0b2ih552zhbbx1fc5ad80nafvkc5my3gw89as4mvycnhyd5inj";

  buildInputs = [ gtk3 libxfce4ui vte ];

  meta = {
    description = "A modern terminal emulator";
  };
}
