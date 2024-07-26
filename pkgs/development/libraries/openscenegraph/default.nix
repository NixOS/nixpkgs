{ stdenv, lib, fetchFromGitHub, fetchpatch, fetchurl, cmake, pkg-config, doxygen,
  libX11, libXinerama, libXrandr, libGLU, libGL,
  glib, libxml2, pcre, zlib,
  AGL, Accelerate, Carbon, Cocoa, Foundation,
  boost,
  jpegSupport ? true, libjpeg,
  exrSupport ? false, openexr_3,
  gifSupport ? true, giflib,
  pngSupport ? true, libpng,
  tiffSupport ? true, libtiff,
  gdalSupport ? false, gdal,
  curlSupport ? true, curl,
  colladaSupport ? false, opencollada,
  opencascadeSupport ? false, opencascade-occt,
  ffmpegSupport ? false, ffmpeg,
  nvttSupport ? false, nvidia-texture-tools,
  freetypeSupport ? true, freetype,
  svgSupport ? false, librsvg,
  pdfSupport ? false, poppler,
  vncSupport ? false, libvncserver,
  lasSupport ? false, libLAS,
  luaSupport ? false, lua,
  sdlSupport ? false, SDL2,
  restSupport ? false, asio,
  withApps ? false,
  withExamples ? false, fltk,
}:

stdenv.mkDerivation rec {
  pname = "openscenegraph";
  version = "3.6.5";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "OpenSceneGraph";
    rev = "OpenSceneGraph-${version}";
    sha256 = "00i14h82qg3xzcyd8p02wrarnmby3aiwmz0z43l50byc9f8i05n1";
  };

  nativeBuildInputs = [ pkg-config cmake doxygen ];

  buildInputs = lib.optionals (!stdenv.isDarwin) [
    libX11 libXinerama libXrandr libGLU libGL
  ] ++ [
    glib libxml2 pcre zlib
  ] ++ lib.optional jpegSupport libjpeg
    ++ lib.optional exrSupport openexr_3
    ++ lib.optional gifSupport giflib
    ++ lib.optional pngSupport libpng
    ++ lib.optional tiffSupport libtiff
    ++ lib.optional gdalSupport gdal
    ++ lib.optional curlSupport curl
    ++ lib.optional colladaSupport opencollada
    ++ lib.optional opencascadeSupport opencascade-occt
    ++ lib.optional ffmpegSupport ffmpeg
    ++ lib.optional nvttSupport nvidia-texture-tools
    ++ lib.optional freetypeSupport freetype
    ++ lib.optional svgSupport librsvg
    ++ lib.optional pdfSupport poppler
    ++ lib.optional vncSupport libvncserver
    ++ lib.optional lasSupport libLAS
    ++ lib.optional luaSupport lua
    ++ lib.optional sdlSupport SDL2
    ++ lib.optional restSupport asio
    ++ lib.optionals withExamples [ fltk ]
    ++ lib.optionals (!stdenv.isDarwin) [  ]
    ++ lib.optionals stdenv.isDarwin [ AGL Accelerate Carbon Cocoa Foundation ]
    ++ lib.optional (restSupport || colladaSupport) boost
    ;

  patches = [
    (fetchpatch {
      name = "opencascade-api-patch";
      url = "https://github.com/openscenegraph/OpenSceneGraph/commit/bc2daf9b3239c42d7e51ecd7947d31a92a7dc82b.patch";
      hash = "sha256-VR8YKOV/YihB5eEGZOGaIfJNrig1EPS/PJmpKsK284c=";
    })
    # OpenEXR 3 support: https://github.com/openscenegraph/OpenSceneGraph/issues/1075
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-games/openscenegraph/files/openscenegraph-3.6.5-openexr3.patch?id=0f642d8f09b589166f0e0c0fc84df7673990bf3f";
      hash = "sha256-fdNbkg6Vp7DeDBTe5Zso8qJ5v9uPSXHpQ5XlGkvputk=";
    })
  ];

  cmakeFlags = lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF" ++ lib.optional withExamples "-DBUILD_OSG_EXAMPLES=ON";

  meta = with lib; {
    description = "3D graphics toolkit";
    homepage = "http://www.openscenegraph.org/";
    maintainers = with maintainers; [ aanderse raskin ];
    platforms = with platforms; linux ++ darwin;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}
