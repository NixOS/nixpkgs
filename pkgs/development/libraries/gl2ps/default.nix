{
  lib,
  stdenv,
  fetchurl,
  cmake,
  zlib,
  libpng,
  libGL,
  libGLU,
  freeglut,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "gl2ps";
  version = "1.4.2";

  src = fetchurl {
    url = "http://geuz.org/gl2ps/src/${pname}-${version}.tgz";
    sha256 = "1sgzv547h7hrskb9qd0x5yp45kmhvibjwj2mfswv95lg070h074d";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      zlib
      libpng
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      libGL
      libGLU
      freeglut
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.OpenGL
    ];

  meta = with lib; {
    homepage = "http://geuz.org/gl2ps";
    description = "An OpenGL to PostScript printing library";
    platforms = platforms.all;
    license = licenses.lgpl2;
    maintainers = with maintainers; [
      raskin
      twhitehead
    ];
  };
}
