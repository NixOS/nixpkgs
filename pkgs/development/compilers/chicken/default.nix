{ stdenv, fetchurl }:

let
  version = "4.9.0";
  platform = with stdenv;
    if isDarwin then "macosx"
    else if isCygwin then "cygwin"
    else if isBSD then "bsd"
    else if isSunOS then "solaris"
    else "linux";               # Should be a sane default
in
stdenv.mkDerivation {
  name = "chicken-${version}";

  src = fetchurl {
    url = "http://code.call-cc.org/releases/4.9.0/chicken-${version}.tar.gz";
    sha256 = "08jaavr3lhs0z2q9k7b7w8l3fsxpms58zxg8nyk8674p54cbwaig";
  };

  buildFlags = "PLATFORM=${platform} PREFIX=$(out) VARDIR=$(out)/var/lib";
  installFlags = "PLATFORM=${platform} PREFIX=$(out) VARDIR=$(out)/var/lib";

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
