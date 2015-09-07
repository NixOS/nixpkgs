{ stdenv, fetchurl, zlib }:

assert !(stdenv ? cross) -> zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.53";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "02jwfqk1ahqfvbs9gdyb5v0123by9ws6m7jnfvainig7i7v4jpml";
  };

  propagatedBuildInputs = [ zlib ];

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
    branch = "1.2";
  };
}
