{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib
, libXinerama, libXft, libXpm, libSM, libXt, freetype, pkgconfig
, fontconfig, makeWrapper ? stdenv.isDarwin
}:

let
  version = "7.2.3";
in
stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/swipl-${version}.tar.gz";
    sha256 = "1da6sr8pz1zffs79nfa1d25a11ibhalm1vdwsb17p265nx8psra3";
  };

  buildInputs = [ gmp readline openssl libjpeg unixODBC libXinerama
    libXft libXpm libSM libXt zlib freetype pkgconfig fontconfig ]
  ++ stdenv.lib.optional stdenv.isDarwin makeWrapper;

  hardeningDisable = [ "format" ];

  configureFlags = "--with-world --enable-gmp --enable-shared";

  buildFlags = "world";

  # For macOS: still not fixed in upstream: "abort trap 6" when called
  # through symlink, so wrap binary.
  # We reinvent wrapProgram here but omit argv0 pass in order to not
  # break PAKCS package build. This is also safe for SWI-Prolog, since
  # there is no wrapping environment and hence no need to spoof $0
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    local prog="$out/bin/swipl"
    local hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    mv $prog $hidden
    makeWrapper $hidden $prog
  '';

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
