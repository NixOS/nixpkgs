{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  imagemagick,
  xwd,
}:

stdenv.mkDerivation rec {
  pname = "ttygif";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "icholy";
    repo = "ttygif";
    rev = version;
    sha256 = "sha256-GsMeVR2wNivQguZ6B/0v39Td9VGHg+m3RtAG9DYkNmU=";
  };

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=${placeholder "out"}"
  ];

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/ttygif \
      --prefix PATH : ${
        lib.makeBinPath [
          imagemagick
          xwd
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/icholy/ttygif";
    description = "Convert terminal recordings to animated gifs";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moaxcp ];
    mainProgram = "ttygif";
  };
}
