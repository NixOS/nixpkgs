{ stdenv, fetchurl, pkgconfig, glib, eggdbus, expat, pam, intltool, gettext }:

stdenv.mkDerivation rec {
  # ... or should we name this package "polkit"?  Upstream doesn't
  # seem to know either...
  name = "PolicyKit-0.92";
  
  src = fetchurl {
    url = http://hal.freedesktop.org/releases/polkit-0.92.tar.gz;
    sha256 = "18x4xp4m14fm4aayra4njh82g2jzf6ccln40yybmhxqpb5a3nii8";
  };
  
  buildInputs = [ pkgconfig glib eggdbus expat pam intltool gettext ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/PolicyKit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
  };
}
