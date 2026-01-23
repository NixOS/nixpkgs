{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  trousers,
  openssl,
  opencryptoki,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tpm-tools";
  version = "1.3.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/trousers/tpm-tools/${finalAttrs.version}/tpm-tools-${finalAttrs.version}.tar.gz";
    hash = "sha256-ivg3lJouwwsZU4msiisxvEn+MVBQdRt9TQ1DK/eBKpc=";
  };

  postPatch = ''
    mkdir -p po
    mkdir -p m4
    cp -R po_/* po/
    touch po/Makefile.in.in
    touch m4/Makefile.am
    substituteInPlace include/tpm_pkcs11.h \
      --replace-fail "libopencryptoki.so" "${opencryptoki}/lib/opencryptoki/libopencryptoki.so"
  '';

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  buildInputs = [
    trousers
    openssl
    opencryptoki
  ];

  meta = {
    description = "Management tools for TPM hardware";
    longDescription = ''
      tpm-tools is an open-source package designed to enable user and
      application enablement of Trusted Computing using a Trusted Platform
      Module (TPM), similar to a smart card environment.
    '';
    homepage = "https://sourceforge.net/projects/trousers/files/tpm-tools/";
    license = lib.licenses.cpl10;
    maintainers = [ lib.maintainers.ak ];
    platforms = lib.platforms.unix;
  };
})
