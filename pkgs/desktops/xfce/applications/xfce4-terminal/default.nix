{ mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf, pcre2 }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "0.8.9.2";

  sha256 = "1vlpfsrdalqmsd86aj0kvvam5skzn6xngigjziwli6q6il6lb9fj";

  buildInputs = [ gtk3 libxfce4ui vte xfconf pcre2 ];

  meta = {
    description = "A modern terminal emulator";
  };
}
