{ lib
, stdenv
, fetchurl
, freetype
, libGL
, libGLU
, OpenGL
}:

stdenv.mkDerivation rec {
  pname = "ftgl";
  version = "2.1.3-rc5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}-${version}.tar.gz";
    hash = "sha256-VFjWISJFSGlXLTn4qoV0X8BdVRgAG876Y71su40mVls=";
  };

  buildInputs = [
    freetype
  ] ++ (if stdenv.isDarwin then [
    OpenGL
  ] else [
    libGL
    libGLU
  ]);

  configureFlags = [
    "--with-ft-prefix=${lib.getDev freetype}"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://sourceforge.net/apps/mediawiki/ftgl/";
    description = "Font rendering library for OpenGL applications";
    longDescription = ''
      FTGL is a free cross-platform Open Source C++ library that uses Freetype2
      to simplify rendering fonts in OpenGL applications. FTGL supports bitmaps,
      pixmaps, texture maps, outlines, polygon mesh, and extruded polygon
      rendering modes.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
