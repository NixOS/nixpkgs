{ stdenv, fetchurl, devSnapshot ? false }:

let
  stableVersion = "4.8.0.6";
  devVersion = "4.9.0rc1";
  version = if devSnapshot then devVersion else stableVersion;
  srcRelease = fetchurl {
    url = "http://code.call-cc.org/releases/4.8.0/chicken-${stableVersion}.tar.gz";
    sha256 = "0an6l09y9pa6r4crkn33w6l4j6nwhvk6fibx2ajv6h0pfl2jqkd5";
  };
  srcDev = fetchurl {
    url = "http://code.call-cc.org/dev-snapshots/2014/04/17/chicken-${devVersion}.tar.gz";
    sha256 = "168f5ib02hh6cnilsrfg103ijhlg4j0z0fgs7i55kzd4aggy1w42";
  };
  platform = with stdenv;
    if isDarwin then "macosx"
    else if isCygwin then "cygwin"
    else if isBSD then "bsd"
    else if isSunOS then "solaris"
    else "linux";               # Should be a sane default
in
stdenv.mkDerivation {
  name = "chicken-${version}";

  src = if devSnapshot
    then srcDev
    else srcRelease;

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
