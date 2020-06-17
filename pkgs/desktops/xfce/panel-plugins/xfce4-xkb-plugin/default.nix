{ lib, mkXfceDerivation, gtk3, librsvg, libwnck3, libxklavier, garcon, libxfce4ui, libxfce4util, xfce4-panel, xfconf }:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-xkb-plugin";
  version = "0.8.1";
  rev-prefix = "";
  sha256 = "1gyky4raynp2ggdnq0g96c6646fjm679fzipcsmf1q0aymr8d5ky";

  buildInputs = [ garcon gtk3 librsvg libxfce4ui libxfce4util libxklavier libwnck3 xfce4-panel xfconf ];

  meta = with lib; {
    description = "Allows you to setup and use multiple keyboard layouts";
    maintainers = [ maintainers.AndersonTorres ];
  };
}
