{ stdenv, fetchurl, pkgconfig, intltool, gobjectIntrospection, libsoup
, libxslt, check, vala_0_23 ? null
}:

stdenv.mkDerivation rec {
  name = "libosinfo-0.2.12";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libosinfo/${name}.tar.gz";
    sha256 = "1vcg8ylh7q69s9y6hj94dqfffwfbann3i28yqgfc01navf6yl07s";
  };

  buildInputs = [
    pkgconfig intltool gobjectIntrospection libsoup libxslt check vala_0_23
  ];

  meta = with stdenv.lib; {
    description = "Info about OSs, hypervisors and (virtual) hardware devices";
    homepage = http://libosinfo.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
