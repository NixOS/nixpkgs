{ stdenv, fetchurl, pkgconfig, intltool, gobjectIntrospection, libsoup
, libxslt, check, vala ? null
}:

stdenv.mkDerivation rec {
  name = "libosinfo-0.2.11";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libosinfo/${name}.tar.gz";
    sha256 = "0889zvidhmpk3nd7c1xhh3fkk9i014dkr6zdlddh89kbflva2sxv";
  };

  buildInputs = [
    pkgconfig intltool gobjectIntrospection libsoup libxslt check vala
  ];

  meta = with stdenv.lib; {
    description = "Info about OSs, hypervisors and (virtual) hardware devices";
    homepage = http://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
