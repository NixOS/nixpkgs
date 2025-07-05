{
  lib,
  stdenv,
  fetchFromGitHub,
  xbitmaps,
  libX11,
  imake,
  gccmakedep,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmountains";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "spbooth";
    repo = "xmountains";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q2+aJ5ISoSXUW4BaAf9Qq/d+DEBSylceZNKKmN4SbQQ=";
  };

  buildInputs = [
    xbitmaps
    libX11
  ];

  nativeBuildInputs = [
    imake
    gccmakedep
  ];

  installPhase = "install -Dm755 xmountains -t $out/bin";

  meta = {
    description = "X11 based fractal landscape generator";
    homepage = "https://spbooth.github.io/xmountains";
    license = lib.licenses.hpndSellVariant;
    maintainers = with lib.maintainers; [ djanatyn ];
    mainProgram = "xmountains";
  };
})
