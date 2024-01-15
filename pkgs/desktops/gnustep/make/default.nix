{ lib, stdenv, fetchurl, clang, which, libobjc }:

stdenv.mkDerivation rec {
  pname = "gnustep-make";
  version = "2.9.1";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${version}.tar.gz";
    sha256 = "sha256-w9bnDPFWsn59HtJQHFffP5bidIjOLzUbk+R5xYwB6uc=";
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

  nativeBuildInputs = [ clang which ];
  buildInputs = [ libobjc ];

  patches = [ ./fixup-paths.patch ];
  setupHook = ./setup-hook.sh;
  meta = {
    description = "A build manager for GNUstep";
    homepage = "http://gnustep.org/";
    changelog = "https://github.com/gnustep/tools-make/releases/tag/make-${builtins.replaceStrings [ "." ] [ "_" ] version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer ];
    platforms = lib.platforms.unix;
  };
}
