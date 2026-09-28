{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
  libdvdread,
  libdvdcss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vobcopy";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "barak";
    repo = "vobcopy";
    tag = finalAttrs.version;
    hash = "sha256-MuS/a0CYqui3CZW98OIUvOMA9oDFFPzoKIeG6eCGTzo=";
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

  doCheck = true;

  meta = {
    description = "Copies DVD .vob files to harddisk, decrypting them on the way";
    homepage = "https://github.com/barak/vobcopy";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ryand56 ];
    mainProgram = "vobcopy";
  };
})
