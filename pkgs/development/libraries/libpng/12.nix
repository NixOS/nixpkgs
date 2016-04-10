{ stdenv, fetchurl, zlib }:

assert !(stdenv ? cross) -> zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.55";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "0zkra0b9lrpk2axassdgkqinmc2ba6b473sm52xbpyknaqs2fljy";
  };

  outputs = [ "dev" "out" "man" ];

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
  };
}
