{ lib, stdenv, fetchurl, clang, which, libobjc }:

let
  version = "2.9.0";
in

stdenv.mkDerivation {
  pname = "gnustep-make";
  inherit version;

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${version}.tar.gz";
    sha256 = "sha256-oLBmwRJXh5x8hTEd6mnGf23HQe8znbZRT4W2SZLEDSo=";
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
    homepage = "http://gnustep.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer ];
    platforms = lib.platforms.unix;
  };
}
