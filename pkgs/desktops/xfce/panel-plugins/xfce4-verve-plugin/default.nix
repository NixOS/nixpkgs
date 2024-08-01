{ lib
, mkXfceDerivation
, glib
, gtk3
, libxfce4ui
, libxfce4util
, pcre2
, xfce4-panel
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-verve-plugin";
  version = "2.0.3";
  sha256 = "sha256-K335cs1vWKTNQjZlSUuhK8OmgTsKSzN87IZwS4RtvB8=";

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    pcre2
    xfce4-panel
  ];

  meta = with lib; {
    description = "Command-line plugin";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
