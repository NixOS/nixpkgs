{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libXpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xosview";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "hills";
    repo = "xosview";
    rev = finalAttrs.version;
    hash = "sha256-lAVMpdVeYENtJrnRiCVgMbti7fKdQusTBsNCVdJZJkA=";
  };

  outputs = [
    "out"
    "man"
  ];

  dontConfigure = true;

  buildInputs = [
    libX11
    libXpm
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
