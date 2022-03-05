{ lib, stdenv, fetchurl, pkg-config, pure }:

stdenv.mkDerivation rec {
  pname = "pure-doc";
  version = "0.7";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-doc-${version}.tar.gz";
    sha256 = "cfa880573941f37868269bcc443a09fecd2a141a78556383d2213f6c9f45ddd9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pure ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];

  meta = {
    description = "A simple utility for literate programming and documenting source code written in the Pure programming language";
    homepage = "http://puredocs.bitbucket.org/pure-doc.html";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
