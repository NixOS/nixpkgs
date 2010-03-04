{stdenv, fetchurl, libX11, libxcb, pkgconfig, xcbutil}:

let
  version = "0.10";
in
stdenv.mkDerivation {
  name = "libstartup-notification-${version}";
  src = fetchurl {
    url = "http://www.freedesktop.org/software/startup-notification/releases/startup-notification-${version}.tar.gz";
    sha256 = "0nalaay0yj3gq85insp9l31hsv5zp390m4nn37y235v151ffpfv4";
  };

  buildInputs = [ libX11 libxcb pkgconfig xcbutil ];

  meta = {
    homepage = http://www.freedesktop.org/software/startup-notification;
    description = "Application startup notification and feedback library";
    license = "BSD";
  };
}
