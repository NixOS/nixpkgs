{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, doxygen
, freeglut
, freetype
, libGL
, libGLU
, pkg-config
, darwin
}:

let
  inherit (darwin.apple_sdk.frameworks) OpenGL GLUT;
in
stdenv.mkDerivation rec {
  pname = "ftgl";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "frankheckenbach";
    repo = "ftgl";
    rev = "v${version}";
    hash = "sha256-6TDNGoMeBLnucmHRgEDIVWcjlJb7N0sTluqBwRMMWn4=";
  };

  # GL_DYLIB is hardcoded to an impure path
  # /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib
  # and breaks build on recent macOS versions
  postPatch = ''
    substituteInPlace m4/gl.m4 \
      --replace ' -dylib_file $GL_DYLIB: $GL_DYLIB' ""
  '';

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
  ];
  buildInputs = [
    freetype
  ] ++ (if stdenv.isDarwin then [
    OpenGL
    GLUT
  ] else [
    libGL
    libGLU
    freeglut
  ]);

  configureFlags = [
    "--with-ft-prefix=${lib.getDev freetype}"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm644 src/FTSize.h -t ${placeholder "out"}/include/FTGL
    install -Dm644 src/FTFace.h -t ${placeholder "out"}/include/FTGL
  '';

  meta = with lib; {
    homepage = "https://github.com/frankheckenbach/ftgl";
    description = "Font rendering library for OpenGL applications";
    longDescription = ''
      FTGL is a free cross-platform Open Source C++ library that uses Freetype2
      to simplify rendering fonts in OpenGL applications. FTGL supports bitmaps,
      pixmaps, texture maps, outlines, polygon mesh, and extruded polygon
      rendering modes.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
