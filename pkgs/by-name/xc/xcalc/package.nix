{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  wrapWithXFileSearchPathHook,
  libx11,
  libxaw,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xcalc";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://xorg/individual/app/xcalc-${finalAttrs.version}.tar.xz";
    hash = "sha256-hXjfoUV+lCifbW7WFGcUMH2Kc6G1TS9CrxMhtiX8HNQ=";
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
    description = "Scientific calculator X11 client that can emulate a TI-30 or an HP-10C";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xcalc";
    license = with lib.licenses; [
      x11
      hpndSellVariant
    ];
    mainProgram = "xcalc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
