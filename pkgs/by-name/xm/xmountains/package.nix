{
  lib,
  stdenv,
  fetchFromGitHub,
  xbitmaps,
  libX11,
  imake,
  gccmakedep,
}:

stdenv.mkDerivation (final: {
  pname = "xmountains";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "spbooth";
    repo = "xmountains";
    rev = "aa3bcbfed228adf3fff0fe4295589f13fc194f0b";
    hash = "sha256-SeWkTToT7Ki/UYak5l/h8xeLeAuXBSI1AZuacbywpDc=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-int";

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
