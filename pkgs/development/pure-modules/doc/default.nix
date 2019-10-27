{ stdenv, fetchurl, pkgconfig, pure }:

stdenv.mkDerivation rec {
  baseName = "doc";
  version = "0.7";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "cfa880573941f37868269bcc443a09fecd2a141a78556383d2213f6c9f45ddd9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];

  meta = {
    description = "A simple utility for literate programming and documenting source code written in the Pure programming language";
    homepage = http://puredocs.bitbucket.org/pure-doc.html;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
