{
  lib,
  stdenv,
  fetchurl,
  which,
  libobjc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-make";
  version = "2.9.1";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${finalAttrs.version}.tar.gz";
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

  buildInputs = [ libobjc ];

  propagatedBuildInputs = [ which ];

  patches = [ ./fixup-paths.patch ];
  setupHook = ./setup-hook.sh;

  meta = {
    changelog = "https://github.com/gnustep/tools-make/releases/tag/make-${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    description = "A build manager for GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      ashalkhakov
      matthewbauer
      dblsaiko
    ];
    platforms = lib.platforms.unix;
  };
})
