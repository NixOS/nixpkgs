{ mkXfceDerivation, gtk3, libxfce4ui, vte, xfconf }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "0.8.8";

  sha256 = "0sg9vwyvhh7pjp83biv7gvf42423a7ly4dc7q2gn28kp6bds2qcp";

  buildInputs = [ gtk3 libxfce4ui vte xfconf ];

  meta = {
    description = "A modern terminal emulator";
  };
}
