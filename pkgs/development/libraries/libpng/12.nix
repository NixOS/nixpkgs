{ stdenv, fetchurl, zlib }:

assert !(stdenv ? cross) -> zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.56";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "1ghd03p353x0vi4dk83n1nlldg11w7vqdk3f99rkgfb82ic59ki4";
  };

  outputs = [ "out" "dev" "man" ];

  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };

  crossAttrs = stdenv.lib.optionalAttrs (stdenv.cross.libc == "libSystem") {
    propagatedBuildInputs = [];
    passthru = {};
  };

  configureFlags = "--enable-static";

  postInstall = ''mv "$out/bin" "$dev/bin"'';

  meta = with stdenv.lib; {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = licenses.libpng;
    maintainers = [ maintainers.fuuzetsu ];
    branch = "1.2";
    platforms = platforms.unix;
  };
}
