{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  pkg-config,
  texinfo,
  ncurses,
  json_c,
  zlib,
  libx11,
  libxft,
  fontconfig,
  cairo,
  pango,
  gpm,
  libvterm,
  librsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwpe";
  version = "1.6.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mendezr";
    repo = "xwpe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VpXQL583bnoJKFBiKSCk09xOx6958RAewZ7S7VS+LXA=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
    librsvg
  ];

  buildInputs = [
    ncurses
    json_c
    zlib
    libx11
    libxft
    fontconfig
    cairo
    pango
    gpm
    libvterm
  ];

  doCheck = true;

  meta = {
    description = "Code editor inspired by Borland C and Pascal family";
    homepage = "https://codeberg.org/mendezr/xwpe";
    changelog = "https://codeberg.org/mendezr/xwpe/releases/tag/v${finalAttrs.version}";
    mainProgram = "xwpe";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
