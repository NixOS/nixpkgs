{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  openssl ? null,
  gpgme ? null,
  gpgSupport ? true,
  sslSupport ? true,
  fetchpatch,
}:

assert gpgSupport -> gpgme != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  pname = "sylpheed";
  version = "3.7.0";

  src = fetchurl {
    url = "https://sylpheed.sraoss.jp/sylpheed/v3.7/${pname}-${version}.tar.xz";
    sha256 = "0j9y5vdzch251s264diw9clrn88dn20bqqkwfmis9l7m8vmwasqd";
  };

  patches = [
    (fetchpatch {
      # patch upstream bug https://sylpheed.sraoss.jp/redmine/issues/306
      name = "patch-libsylph_ssl_c.patch";
      extraPrefix = "";
      url = "https://cvsweb.openbsd.org/cgi-bin/cvsweb/~checkout~/ports/mail/sylpheed/patches/patch-libsylph_ssl_c?rev=1.4&content-type=text/plain";
      sha256 = "sha256-+FetU5vrfvE78nYAjKK/QFZnFw+Zr2PvoUGRWCuZczs=";
    })
    (fetchpatch {
      name = "CVE-2021-37746.patch";
      url = "https://git.claws-mail.org/?p=claws.git;a=patch;h=ac286a71ed78429e16c612161251b9ea90ccd431";
      sha256 = "sha256-oLmUShtvO6io3jibKT67eO0O58vEDZEeaB51QTd3UkU=";
    })
    (fetchurl {
      name = "0013-fix-FTBFS-GCC-14.patch";
      url = "https://salsa.debian.org/sylpheed-team/sylpheed/-/raw/22984c6d2bf76b0667256a9e8b660447497e1220/debian/patches/0013-fix-FTBFS-GCC-14.patch?inline=false";
      sha256 = "sha256-ZfQKiOK8pMrN87hrP0/2LxYZZdnaciBoa0khG1Djelo=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk2
  ]
  ++ lib.optionals gpgSupport [ gpgme ]
  ++ lib.optionals sslSupport [ openssl ];

  configureFlags = lib.optional gpgSupport "--enable-gpgme" ++ lib.optional sslSupport "--enable-ssl";

  # Undefined symbols for architecture arm64: "_OBJC_CLASS_$_NSAutoreleasePool"
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework Foundation";

  meta = with lib; {
    homepage = "https://sylpheed.sraoss.jp/en/";
    description = "Lightweight and user-friendly e-mail client";
    mainProgram = "sylpheed";
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
