{ stdenv, lib, fetchurl }:

stdenv.mkDerivation {
  name = "libcerf-1.5";

  src = fetchurl {
    url = "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.5.tgz";
    sha256 = "11jwr8ql4a9kmv04ycgwk4dsqnlv4l65a8aa0x1i3y7zwx3w2vg3";
  };

  meta = with lib; {
    description = "Complex error (erf), Dawson, Faddeeva, and Voigt function library";
    homepage = http://apps.jcns.fz-juelich.de/doku/sc/libcerf;
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
