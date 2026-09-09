{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  bison,
  flex,
  libice,
  libsm,
  libx11,
  libxext,
  libxmu,
  xorgproto,
  libxrandr,
  libxt,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tab-window-manager";
  version = "1.0.13.1";

  src = fetchurl {
    url = "mirror://xorg/individual/app/twm-${finalAttrs.version}.tar.xz";
    hash = "sha256-pSU0dVqotJLIhOUvqYi6yEq01UZBlUZ5uarwjjI98sU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    bison
    flex
  ];

  buildInputs = [
    xorgproto
    libice
    libsm
    libx11
    libxext
    libxmu
    libxrandr
    libxt
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname twm \
        --url https://xorg.freedesktop.org/releases/individual/app/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "Default Window Manager for the X Window System";
    longDescription = ''
      The Tab Window Manager (twm) is a window manager for the X Window System.
      It provides titlebars, shaped windows, several forms of icon management, user-defined macro
      functions, click-to-type and pointer-driven keyboard focus, and user-specified key and pointer
      button bindings.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/twm";
    license = with lib.licenses; [
      mitOpenGroup
      hpnd
      x11
    ];
    mainProgram = "twm";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
