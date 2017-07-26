{ stdenv, fetchurl, zlib
, buildPlatform, hostPlatform
}:

assert hostPlatform == buildPlatform -> zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.57";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "1n2lrzjkm5jhfg2bs10q398lkwbbx742fi27zgdgx0x23zhj0ihg";
  };

  outputs = [ "out" "dev" "man" ];

  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };

  crossAttrs = stdenv.lib.optionalAttrs (hostPlatform.libc == "libSystem") {
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
