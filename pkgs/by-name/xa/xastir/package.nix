{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bashNonInteractive,
  curl,
  db,
  gnused,
  libgeotiff,
  libtiff,
  xorg,
  motif,
  pcre2,
  perl,
  proj,
  graphicsmagick,
  shapelib,
  libax25,
}:

stdenv.mkDerivation rec {
  pname = "xastir";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "xastir";
    repo = "xastir";
    tag = "Release-${version}";
    hash = "sha256-bpT8F3xURo9jRxBrGGflmcLD6U7F+FTW+VAK1WCgqF4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
  ];

  buildInputs = [
    bashNonInteractive
    curl
    db
    libgeotiff
    libtiff
    xorg.libXpm
    xorg.libXt
    motif
    pcre2
    perl
    proj
    graphicsmagick
    shapelib
    libax25
  ];

  strictDeps = true;

  configureFlags = [
    "--with-motif-includes=${lib.getDev motif}/include"
    "ac_cv_path_gm=${lib.getExe' graphicsmagick "gm"}"
    "ac_cv_path_convert=${lib.getExe' graphicsmagick "convert"}"
    "ac_cv_header_xtiffio_h=yes"
    "ac_cv_path_GMAGIC_BIN=${lib.getExe' (lib.getDev graphicsmagick) "GraphicsMagick-config"}"
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  postPatch = ''
    patchShebangs --build scripts/lang*.pl

    # checks for files in /usr/bin/
    substituteInPlace acinclude.m4 \
      --replace-fail "AC_CHECK_FILE" "# AC_CHECK_FILE"
    # would pick up builder sed from $PATH
    substituteInPlace configure.ac \
      --replace-fail 'AC_DEFINE_UNQUOTED(SED_PATH, "''${sed}", [Path to sed])' \
                     'AC_DEFINE_UNQUOTED(SED_PATH, "${lib.getExe gnused}", [Path to sed])'
  '';

  preInstall = ''
    patchShebangs --host --update .
  '';

  meta = {
    description = "Graphical APRS client";
    homepage = "https://github.com/xastir/xastir";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
