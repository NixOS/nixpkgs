{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxcb,
  libxcb-util,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xbacklight";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xbacklight-${finalAttrs.version}.tar.xz";
    hash = "sha256-1MMLDm8YyC84dYWnN+47ctRoySeJKwiomMQbwSJI6O4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxcb
    libxcb-util
  ];

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
    description = "Utility to adjust X backlight brightness using RandR extension";
    longDescription = ''
      Xbacklight is used to adjust the backlight brightness where supported.
      It uses the RandR extension to find all outputs on the X server supporting backlight
      brightness control and changes them all in the same way.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/xbacklight";
    license = lib.licenses.hpndSellVariant;
    mainProgram = "xbacklight";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
