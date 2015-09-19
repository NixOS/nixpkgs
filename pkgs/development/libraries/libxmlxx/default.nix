{ stdenv, fetchurl, pkgconfig, libxml2, glibmm, perl }:

stdenv.mkDerivation rec {
  name = "libxml++-2.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml++/2.38/${name}.tar.xz";
    sha256 = "0px0ljcf9rsfa092dzmm097yn7wln6d5fgsvj9lnrnq3kcc2j9c8";
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
