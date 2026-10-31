{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  libxcb-util,
  libxcb-wm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdo";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "baskerville";
    repo = "xdo";
    rev = finalAttrs.version;
    sha256 = "1h3jrygcjjbavdbkpx2hscsf0yf97gk487lzjdlvymd7dxdv9hy9";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    libxcb
    libxcb-wm
    libxcb-util
  ];

  meta = {
    description = "Small X utility to perform elementary actions on windows";
    homepage = "https://github.com/baskerville/xdo";
    maintainers = with lib.maintainers; [ meisternu ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    mainProgram = "xdo";
  };
})
