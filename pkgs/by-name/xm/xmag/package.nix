{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wrapWithXFileSearchPathHook,
  xorgproto,
  libx11,
  libxaw,
  libxmu,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xmag";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xmag-${finalAttrs.version}.tar.xz";
    hash = "sha256-Mm08WD15W7U6xgnRROf3+xSZurp+rsFLjmzSMuoGlTI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
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
    description = "Utility to display a magnified snapshot of a portion of an X11 screen.";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xmag";
    license = with lib.licenses; [
      mitOpenGroup
      x11
    ];
    mainProgram = "xmag";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
