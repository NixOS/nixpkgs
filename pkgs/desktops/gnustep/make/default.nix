{
  lib,
  stdenv,
  fetchurl,
  which,
  libobjc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-make";
  version = "2.9.2";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-9UDfnw4drrPSOwjhSyBLKkbx0KQAXLFxyVMjQTgG5OE=";
  };

  configureFlags = [
    "--with-layout=fhs-system"
    "--disable-install-p"
    "--with-config-file=${placeholder "out"}/etc/GNUstep/GNUstep.conf"
  ];

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
    description = "Build manager for GNUstep";
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
