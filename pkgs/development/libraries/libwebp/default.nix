{ stdenv, fetchurl
, threadingSupport ? true # multi-threading
, openglSupport ? false, freeglut ? null, libGL ? null, libGLU ? null # OpenGL (required for vwebp)
, pngSupport ? true, libpng ? null # PNG image format
, jpegSupport ? true, libjpeg ? null # JPEG image format
, tiffSupport ? true, libtiff ? null # TIFF image format
, gifSupport ? true, giflib ? null # GIF image format
#, wicSupport ? true # Windows Imaging Component
, alignedSupport ? false # Force aligned memory operations
, swap16bitcspSupport ? false # Byte swap for 16bit color spaces
, experimentalSupport ? false # Experimental code
, libwebpmuxSupport ? true # Build libwebpmux
, libwebpdemuxSupport ? true # Build libwebpdemux
, libwebpdecoderSupport ? true # Build libwebpdecoder
}:

assert openglSupport -> freeglut != null && libGL != null && libGLU != null;
assert pngSupport -> (libpng != null);
assert jpegSupport -> (libjpeg != null);
assert tiffSupport -> (libtiff != null);
assert gifSupport -> (giflib != null);

let
  mkFlag = optSet: flag: if optSet then "--enable-${flag}" else "--disable-${flag}";
in

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "libwebp";
  version = "1.0.3";

  src = fetchurl {
    url = "http://downloads.webmproject.org/releases/webp/${pname}-${version}.tar.gz";
    sha256 = "0kxk4sic34bln3k09mml7crvrmhj97swdk7b1ahbp5w6bj30f2p2";
  };

  configureFlags = [
    (mkFlag threadingSupport "threading")
    (mkFlag openglSupport "gl")
    (mkFlag pngSupport "png")
    (mkFlag jpegSupport "jpeg")
    (mkFlag tiffSupport "tiff")
    (mkFlag gifSupport "gif")
    #(mkFlag (wicSupport && stdenv.isCygwin) "wic")
    (mkFlag alignedSupport "aligned")
    (mkFlag swap16bitcspSupport "swap-16bit-csp")
    (mkFlag experimentalSupport "experimental")
    (mkFlag libwebpmuxSupport "libwebpmux")
    (mkFlag libwebpdemuxSupport "libwebpdemux")
    (mkFlag libwebpdecoderSupport "libwebpdecoder")
  ];

  buildInputs = [ ]
    ++ optionals openglSupport [ freeglut libGL libGLU ]
    ++ optional pngSupport libpng
    ++ optional jpegSupport libjpeg
    ++ optional tiffSupport libtiff
    ++ optional gifSupport giflib;

  enableParallelBuilding = true;

  meta = {
    description = "Tools and library for the WebP image format";
    homepage = "https://developers.google.com/speed/webp/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ codyopel ];
  };
}
