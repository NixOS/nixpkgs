{ stdenv, fetchurl, gtk, libgnomecanvas, pkgconfig }:
 
stdenv.mkDerivation rec {
  name = "phat-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "http://download.berlios.de/phat/${name}.tar.gz";
    sha256 = "1icncp2d8hbarzz8mmflkw13blg7blgwfic8q2wll7s6n01ii2av";
  };

  buildInputs = [ gtk libgnomecanvas pkgconfig ];

  meta = with stdenv.lib; {
    description = "GTK+ widgets geared toward pro-audio apps";
    homepage = http://phat.berlios.de;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
