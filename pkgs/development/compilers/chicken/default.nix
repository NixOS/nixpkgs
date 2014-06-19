{ stdenv, fetchurl }:

let
  version = "4.9.0.1";
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
    sha256 = "0598mar1qswfd8hva9nqs88zjn02lzkqd8fzdd21dz1nki1prpq4";
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
