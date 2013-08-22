{ stdenv, fetchurl,
 cmake, qt4, clucene_core, librdf_redland, libiodbc
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libkolab-0.4.2";

  src = fetchurl {
    url = "http://mirror.kolabsys.com/pub/releases/${name}.tar.gz";
    sha256 = "1wdbg42s14p472dn35n6z638i6n64f6mjjxmjam1r54pzsdykks6";
  };

  # We disable the Java backend, since we do not need them and they make the closure size much bigger
#  buildInputs = [ qt4 clucene_core librdf_redland libiodbc ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ phreedo ];
    inherit (qt4.meta) platforms;
  };
}
