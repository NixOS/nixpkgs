{ lib
, mkXfceDerivation
, exo
, libxml2
, libsoup_3
, libxfce4ui
, libxfce4util
, xfce4-panel
, xfconf
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-screenshooter";
  version = "1.10.2";
  odd-unstable = false;

  sha256 = "sha256-UpfQgKcrxFm7VvMEVV4fsvRnJPZSLJWexx9lZlFWJW8=";

  buildInputs = [
    exo
    libxml2
    libsoup_3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Screenshot utility for the Xfce desktop";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
