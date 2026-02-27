{
  lib,
  stdenv,
  meson,
  ninja,
  fetchurl,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_43,
  gettext,
  makeBinaryWrapper,
  libiconv,
  libintl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-user-dirs";
  version = "0.19";

  src = fetchurl {
    url = "https://user-dirs.freedesktop.org/releases/xdg-user-dirs-${finalAttrs.version}.tar.xz";
    hash = "sha256-6S3rkpwQ1LKTKTl6+KJYUQEkf35hd6xvHSjoITDtjBk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    makeBinaryWrapper
    libxslt
    docbook_xsl
    docbook_xml_dtd_43
    gettext
  ];

  buildInputs = [
    libiconv
    libintl
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  preFixup = ''
    # fallback values need to be last
    wrapProgram "$out/bin/xdg-user-dirs-update" \
      --suffix XDG_CONFIG_DIRS : "$out/etc/xdg"

    substituteInPlace "$out/lib/systemd/user/xdg-user-dirs.service" \
      --replace-fail "/usr/bin/xdg-user-dirs-update" "$out/bin/xdg-user-dirs-update"
  '';

  meta = {
    homepage = "http://freedesktop.org/wiki/Software/xdg-user-dirs";
    description = "Tool to help manage well known user directories like the desktop folder and the music folder";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      donovanglover
      iFreilicht
    ];
    platforms = lib.platforms.unix;
    mainProgram = "xdg-user-dirs-update";
  };
})
