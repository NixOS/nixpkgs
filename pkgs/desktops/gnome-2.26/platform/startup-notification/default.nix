{stdenv, fetchurl, pkgconfig, libX11, libxcb, libICE, xcbutil, libSM}:

stdenv.mkDerivation {
  name = "startup-notification-0.10";
  src = fetchurl {
    url = http://freedesktop.org/software/startup-notification/releases/startup-notification-0.10.tar.gz;
    sha256 = "0nalaay0yj3gq85insp9l31hsv5zp390m4nn37y235v151ffpfv4";
  };
  buildInputs = [ pkgconfig libX11 libxcb libICE xcbutil libSM ];
}
