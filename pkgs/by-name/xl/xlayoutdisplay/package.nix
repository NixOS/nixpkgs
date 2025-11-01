{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorg,
  boost,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlayoutdisplay";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "xlayoutdisplay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gJucWffchhTFdYEQqjbj1OdPTBSmGDDcKbOyIWdWQig=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with xorg; [
    libX11
    libXrandr
    libXcursor
    boost
  ];
  nativeCheckInputs = [ gtest ];

  doCheck = true;
  checkTarget = "gtest";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  enableParallelBuilding = true;

  meta = {
    description = "Detects and arranges linux display outputs, using XRandR for detection and xrandr for arrangement";
    homepage = "https://github.com/alex-courtis/xlayoutdisplay";
    maintainers = with lib.maintainers; [
      dtzWill
      stephen-huan
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "xlayoutdisplay";
  };
})
