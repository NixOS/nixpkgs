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
  version = "2.15";

  src = fetchFromGitHub {
    owner = "spbooth";
    repo = "xmountains";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xAXEa2QQgWR88o6Zx9ZtXXFYerJByqQ1FojaVkru/O8=";
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
