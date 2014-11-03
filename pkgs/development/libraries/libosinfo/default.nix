{ stdenv, fetchurl, pkgconfig, intltool, gobjectIntrospection, libsoup
, libxslt, check, vala ? null
}:

stdenv.mkDerivation rec {
  name = "libosinfo-0.2.10";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libosinfo/${name}.tar.gz";
    sha256 = "564bd487a39dc09a10917c1d7a95f739ee7701d9cd0fbabcacea64f615e20a2d";
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
