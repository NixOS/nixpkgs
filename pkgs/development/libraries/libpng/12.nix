{ stdenv, fetchurl, zlib, xz }:

assert !(stdenv ? cross) -> zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.51";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "0jkdlmnvn72jwm94dp98pznm9fy7alvcr2zpfh2dgbr2n09vimy7";
  };

  propagatedBuildInputs = [ zlib ];

  nativeBuildInputs = [ xz ];

  passthru = { inherit zlib; };

  crossAttrs = stdenv.lib.optionalAttrs (stdenv.cross.libc == "libSystem") {
    propagatedBuildInputs = [];
    passthru = {};
  };

  configureFlags = "--enable-static";

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = stdenv.lib.licenses.libpng;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
