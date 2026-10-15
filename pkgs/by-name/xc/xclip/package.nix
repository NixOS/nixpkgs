{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libxmu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xclip";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "astrand";
    repo = "xclip";
    rev = finalAttrs.version;
    hash = "sha256-mn1GNsYzING+vVYmIP6xRnr6uFAS/hsgzAptKtmuEGA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ libxmu ];

  # Make AC_CHECK_LIB(Xmu, XmuClientWindow) work.
  preConfigure = lib.optionalString stdenv.hostPlatform.isStatic ''
    configureFlagsArray+=("LIBS=$("$PKG_CONFIG" --libs xmu)")
  '';

  meta = {
    description = "Tool to access the X clipboard from a console application";
    homepage = "https://github.com/astrand/xclip";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "xclip";
  };
})
