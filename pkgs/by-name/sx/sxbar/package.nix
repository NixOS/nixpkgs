{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxinerama,
  libxft,
  freetype,
  fontconfig,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "sxbar";
  version = "1.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uint23";
    repo = "sxbar";
    tag = "v1.0";
    hash = "sha256-wAOTUUpMAnnvFOQKgs7BCAg+CurrpY1bQL8hW3DMPps=";
  };

  postPatch = ''
    substituteInPlace src/parser.c \
      --replace-fail '"/usr/local/share/sxbarc"' "\"$out/share/sxbarc\""
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxinerama
    libxft
    freetype
    fontconfig
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "The simple, yet powerful, status bar for Xorg";
    homepage = "https://github.com/uint23/sxbar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ r1w1s1 ];
    mainProgram = "sxbar";
    platforms = lib.platforms.linux;
  };
}
