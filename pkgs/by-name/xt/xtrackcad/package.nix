{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  gtk2,
  pandoc,
  libsysprof-capture,
  pcre2,
  glib,
  util-linux,
  libselinux,
  libsepol,
  fribidi,
  libthai,
  libdatrie,
  libxdmcp,
  libdeflate,
  lerc,
  xz,
  zstd,
  libwebp,
  inkscape,
  libzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtrackcad";
  version = "5.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/xtrkcad-fork/xtrkcad-source-${finalAttrs.version}GA.tar.gz";
    hash = "sha256-WwKgNSwj+QsAEQKcfiw/Eqb2d5QlxMR8H3XWuKDbVyw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtk2
    pandoc
    libsysprof-capture
    pcre2
    glib
    util-linux
    libselinux
    libsepol
    fribidi
    libthai
    libdatrie
    libxdmcp
    libdeflate
    lerc
    xz
    zstd
    libwebp
    inkscape
    libzip
  ];

  meta = {
    description = "Model Railway CAD program";
    homepage = "https://sourceforge.net/projects/xtrkcad-fork/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "xtrkcad";
    platforms = lib.platforms.linux;
  };
})
