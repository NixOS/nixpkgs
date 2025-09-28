{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  xorg,
  boost,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlayoutdisplay";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "xlayoutdisplay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A37jFhVTW/3QNEf776Oi3ViRK+ebOPRTsEQqdmNhA7E=";
  };

  patches = [
    # https://github.com/alex-courtis/xlayoutdisplay/pull/34
    (fetchpatch2 {
      name = "cpp-version.patch";
      url = "https://github.com/alex-courtis/xlayoutdisplay/commit/56983b45070edde78cc816d9cff4111315e94a7a.patch";
      hash = "sha256-zd28Nkw8Kmm20zGT6wvdBHcHfE4p+RFotUO9zJwPQMc=";
    })
  ];

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
    maintainers = with lib.maintainers; [ dtzWill ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "xlayoutdisplay";
  };
})
