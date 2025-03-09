{
  lib,
  stdenv,
  fetchFromGitHub,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "xmountains";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "spbooth";
    repo = pname;
    rev = "aa3bcbfed228adf3fff0fe4295589f13fc194f0b";
    hash = "sha256-SeWkTToT7Ki/UYak5l/h8xeLeAuXBSI1AZuacbywpDc=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-int";

  buildInputs = [
    xorg.xbitmaps
    xorg.libX11
  ];
  nativeBuildInputs = with xorg; [
    imake
    gccmakedep
  ];

  installPhase = "install -Dm755 xmountains -t $out/bin";

  meta = with lib; {
    description = "X11 based fractal landscape generator";
    homepage = "https://spbooth.github.io/xmountains";
    license = licenses.hpndSellVariant;
    maintainers = with maintainers; [ djanatyn ];
    mainProgram = "xmountains";
  };
}
