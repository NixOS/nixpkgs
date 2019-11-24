{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, doxygen,
  libX11, libXinerama, libXrandr, libGLU, libGL,
  glib, ilmbase, libxml2, pcre, zlib,
  jpegSupport ? true, libjpeg,
  jasperSupport ? false, jasper,  # disable jasper by default (many CVE)
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
  pname = "openscenegraph";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "OpenSceneGraph";
    rev = "OpenSceneGraph-${version}";
    sha256 = "0x8hdbzw0b71j91fzp9cwmy9a7ava8v8wwyj8nxijq942vdx1785";
  };

  nativeBuildInputs = [ pkgconfig cmake doxygen ];

  buildInputs = [
    libX11 libXinerama libXrandr libGLU libGL
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

  cmakeFlags = lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF" ++ lib.optional withExamples "-DBUILD_OSG_EXAMPLES=ON";

  meta = with stdenv.lib; {
    description = "A 3D graphics toolkit";
    homepage = http://www.openscenegraph.org/;
    maintainers = with maintainers; [ aanderse raskin ];
    platforms = platforms.linux;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}
