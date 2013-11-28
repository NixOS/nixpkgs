{ stdenv, fetchurl, devSnapshot ? false }:

let
  version = if devSnapshot
    then "4.8.2"
    else "4.8.0.5";
  srcRelease = fetchurl {
    url = "http://code.call-cc.org/releases/4.8.0/chicken-4.8.0.5.tar.gz";
    sha256 = "1yrhqirqj3l535zr5mv8d1mz9gq876wwwg4nsjfw27663far54av";
  };
  srcDev = fetchurl {
    url = "http://code.call-cc.org/dev-snapshots/2013/08/08/chicken-4.8.2.tar.gz";
    sha256 = "01g7h0664342nl536mnri4c72kwj4z40vmv1250xfndlr218qdqg";
  };
in
stdenv.mkDerivation {
  name = "chicken-${version}";

  src = if devSnapshot
    then srcDev
    else srcRelease;

  buildFlags = "PLATFORM=linux PREFIX=$(out) VARDIR=$(out)/var/lib";
  installFlags = "PLATFORM=linux PREFIX=$(out) VARDIR=$(out)/var/lib";

  meta = {
    homepage = http://www.call-cc.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = stdenv.lib.platforms.all;
    description = "A portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the R5RS Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, MacOS X,
      Windows, and many Unix flavours.
    '';
  };
}
