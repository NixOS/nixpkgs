{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  wrapWithXFileSearchPathHook,
  xorgproto,
  libx11,
  libxaw,
  libxmu,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xfontsel";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xfontsel-${finalAttrs.version}.tar.xz";
    hash = "sha256-eP8Bh1fHsiE3z101Ju9ek4i8DN6tHwDa8siY4uJ0VT8=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapWithXFileSearchPathHook
  ];

  buildInputs = [
    xorgproto
    libx11
    libxaw
    libxmu
    libxt
  ];

  installFlags = [ "appdefaultdir=$(out)/share/X11/app-defaults" ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Allows testing the fonts available in an X server";
    longDescription = ''
      xfontsel provides a simple way to display the X11 core protocol fonts known to your X server,
      examine samples of each, and retrieve the X Logical Font Description ("XLFD") full name for a
      font.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xfontsel";
    license = with lib.licenses; [
      x11
      hpnd
      mit
    ];
    mainProgram = "xfontsel";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
