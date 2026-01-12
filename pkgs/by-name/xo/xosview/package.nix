{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xosview";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "hills";
    repo = "xosview";
    rev = finalAttrs.version;
    hash = "sha256-9Pr7voJiCH7oBziMFRHCWxoyuGdndcdRD2POjiNT7yw=";
  };

  outputs = [
    "out"
    "man"
  ];

  dontConfigure = true;

  buildInputs = [
    libx11
    libxpm
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "PLATFORM=linux"
  ];

  meta = {
    homepage = "http://www.pogo.org.uk/~mark/xosview/";
    description = "Classic system monitoring tool";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xosview";
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
})
