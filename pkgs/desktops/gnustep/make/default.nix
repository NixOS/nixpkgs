{ stdenv, fetchurl, clang, which, libobjc }:

let
  version = "2.7.0";
in

stdenv.mkDerivation rec {
  name = "gnustep-make-${version}";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${version}.tar.gz";
    sha256 = "1khiygfkz0zhh9b5nybn40g0xnnjxchk24n49hff1bwanszir84h";
  };

  configureFlags = [
    "--with-layout=fhs-system"
    "--disable-install-p"
  ];

  preConfigure = ''
    configureFlags="$configureFlags --with-config-file=$out/etc/GNUstep/GNUstep.conf"
  '';

  makeFlags = [
    "GNUSTEP_INSTALLATION_DOMAIN=SYSTEM"
  ];

  buildInputs = [ clang which libobjc ];
  patches = [ ./fixup-paths.patch ];
  setupHook = ./setup-hook.sh;
  meta = {
    description = "A build manager for GNUstep";
    homepage = http://gnustep.org/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ ashalkhakov matthewbauer ];
    platforms = stdenv.lib.platforms.unix;
  };
}
