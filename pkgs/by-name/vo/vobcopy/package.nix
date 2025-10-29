{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  libdvdread,
  libdvdcss,
}:

stdenv.mkDerivation {
  pname = "vobcopy";
  version = "1.2.1-unstable-2023-08-29";

  src = fetchFromGitHub {
    owner = "barak";
    repo = "vobcopy";
    rev = "cb560b3a67358f51d51ecc0e511f49f09f304a13";
    hash = "sha256-2EtSO39yOFoCZ5GMqtp+SvmzqSevlqYDo73p0lVHZ3o=";
  };

  # Based on https://github.com/barak/vobcopy/issues/14, but also fixes
  # "error: call to undeclared function 'fdatasync'". The latter patch
  # is inspired by https://github.com/php/php-src/commit/e69729f2ba02ddc26c70b4bd88ef86c0a2277bdc
  patches = [ ./fix-darwin.patch ];

  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs = [
    gettext # Fails on Darwin otherwise
    libdvdread
    libdvdcss
  ];

  meta = {
    description = "Copies DVD .vob files to harddisk, decrypting them on the way";
    homepage = "https://github.com/barak/vobcopy";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "vobcopy";
  };
}
