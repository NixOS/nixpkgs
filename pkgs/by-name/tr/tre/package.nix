{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  gettext,
  libiconv,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tre";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "laurikari";
    repo = "tre";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5O8yqzv+SR8x0X7GtC2Pjo94gp0799M2Va8wJ4EKyf8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext # autopoint
    libtool
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  patches = lib.optionals stdenv.hostPlatform.isMinGW [
    # MSYS2 mingw-w64-libtre patch stack:
    # fix-nixpkgs/MINGW-packages/mingw-w64-libtre/{001-autotools.patch,002-pointer-cast.patch}
    ./mingw/001-autotools.patch
    ./mingw/002-pointer-cast.patch
  ];

  preConfigure = ''
    ./utils/autogen.sh
  '';

  meta = {
    description = "Lightweight and robust POSIX compliant regexp matching library";
    homepage = "https://laurikari.net/tre/";
    changelog = "https://github.com/laurikari/tre/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    mainProgram = "agrep";
    # MSYS2 provides libtre for MinGW (mingw-w64-libtre).
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
