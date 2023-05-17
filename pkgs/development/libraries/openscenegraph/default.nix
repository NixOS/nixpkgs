{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, doxygen,
  libX11, libXinerama, libXrandr, libGLU, libGL,
  glib, ilmbase, libxml2, pcre, zlib,
  AGL, Accelerate, Carbon, Cocoa, Foundation,
  boost,
  jpegSupport ? true, libjpeg,
  exrSupport ? false, openexr,
  gifSupport ? true, giflib,
  pngSupport ? true, libpng,
  tiffSupport ? true, libtiff,
  gdalSupport ? false, gdal,
  curlSupport ? true, curl,
  colladaSupport ? false, collada-dom,
  opencascadeSupport ? false, opencascade,
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

  buildInputs = [
    libX11 libXinerama libXrandr libGLU libGL
    glib ilmbase libxml2 pcre zlib
  ] ++ lib.optional jpegSupport libjpeg
    ++ lib.optional exrSupport openexr
    ++ lib.optional gifSupport giflib
    ++ lib.optional pngSupport libpng
    ++ lib.optional tiffSupport libtiff
    ++ lib.optional gdalSupport gdal
    ++ lib.optional curlSupport curl
    ++ lib.optional colladaSupport collada-dom
    ++ lib.optional opencascadeSupport opencascade
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
    ++ lib.optionals stdenv.isDarwin [ AGL Accelerate Carbon Cocoa Foundation ]
    ++ lib.optional (restSupport || colladaSupport) boost
  ;

  cmakeFlags = lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF" ++ lib.optional withExamples "-DBUILD_OSG_EXAMPLES=ON";

  meta = with lib; {
    description = "A 3D graphics toolkit";
    homepage = "http://www.openscenegraph.org/";
    maintainers = with maintainers; [ aanderse raskin ];
    platforms = with platforms; linux ++ darwin;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}
