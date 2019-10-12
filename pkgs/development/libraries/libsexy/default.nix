{ stdenv, fetchurl, pkgconfig
, glib, gtk2, libxml2, pango
}:

stdenv.mkDerivation {
  name = "libsexy-0.1.11";

  src = fetchurl {
    url = http://releases.chipx86.com/libsexy/libsexy/libsexy-0.1.11.tar.gz;
    sha256 = "8c4101a8cda5fccbba85ba1a15f46f2cf75deaa8b3c525ce5b135b9e1a8fe49e";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib gtk2 libxml2 pango ];

  meta = with stdenv.lib; {
    description = "A collection of GTK widgets";
    homepage = https://blog.chipx86.com/tag/libsexy/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
