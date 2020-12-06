{ stdenv, fetchurl, clang, which, libobjc }:

let
  version = "2.8.0";
in

stdenv.mkDerivation {
  pname = "gnustep-make";
  inherit version;

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${version}.tar.gz";
    sha256 = "0pfaylrr3xgn5026anmja4rv4l7nzzaqsrkxycyi0p4lvm12kklz";
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
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ ashalkhakov matthewbauer ];
    platforms = stdenv.lib.platforms.unix;
  };
}
