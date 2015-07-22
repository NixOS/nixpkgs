{ stdenv, fetchurl, pkgconfig, libxml2, glibmm, perl }:

stdenv.mkDerivation rec {
  name = "libxml++-2.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/2.38/${name}.tar.xz";
    sha256 = "0ihk7fprpshs0gp38x2m5jhvrph3iwr0wy1h1qqvh3rjblzv162n";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [ glibmm ];

  propagatedBuildInputs = [ libxml2 ];

  configureFlags = "--disable-documentation"; #doesn't build without this for some reason

  meta = with stdenv.lib; {
    homepage = http://libxmlplusplus.sourceforge.net/;
    description = "C++ wrapper for the libxml2 XML parser library";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ phreedom wkennington ];
  };
}
