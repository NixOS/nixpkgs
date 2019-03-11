{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, doxygen,
  libX11, libXinerama, libXrandr, libGLU_combined,
  glib, ilmbase, libxml2, pcre, zlib,
  jpegSupport ? true, libjpeg,
  jasperSupport ? true, jasper,
  exrSupport ? false, openexr,
  gifSupport ? true, giflib,
  pngSupport ? true, libpng,
  tiffSupport ? true, libtiff,
  gdalSupport ? false, gdal,
  curlSupport ? true, curl,
  colladaSupport ? false, opencollada,
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
  restSupport ? false, asio, boost,
  withApps ? false,
  withExamples ? false, fltk, wxGTK,
}:

stdenv.mkDerivation rec {
  name = "openscenegraph-${version}";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "OpenSceneGraph";
    rev = "d011ca4e8d83549a3688bf6bb8cd468dd9684822";
    sha256 = "0h32z15sa8sbq276j0iib0n707m8bs4p5ji9z2ah411446paad9q";
  };

  nativeBuildInputs = [ pkgconfig cmake doxygen ];

  buildInputs = [
    libX11 libXinerama libXrandr libGLU_combined
    glib ilmbase libxml2 pcre zlib
  ] ++ lib.optional jpegSupport libjpeg
    ++ lib.optional jasperSupport jasper
    ++ lib.optional exrSupport openexr
    ++ lib.optional gifSupport giflib
    ++ lib.optional pngSupport libpng
    ++ lib.optional tiffSupport libtiff
    ++ lib.optional gdalSupport gdal
    ++ lib.optional curlSupport curl
    ++ lib.optional colladaSupport opencollada
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
    ++ lib.optionals restSupport [ asio boost ]
    ++ lib.optionals withExamples [ fltk wxGTK ]
  ;

  enableParallelBuilding = true;

  cmakeFlags = lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF" ++ lib.optional withExamples "-DBUILD_OSG_EXAMPLES=ON";

  meta = with stdenv.lib; {
    description = "A 3D graphics toolkit";
    homepage = http://www.openscenegraph.org/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}
