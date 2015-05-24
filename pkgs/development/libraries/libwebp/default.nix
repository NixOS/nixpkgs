{ stdenv, fetchurl
, threadingSupport ? true # multi-threading
, openglSupport ? false, freeglut ? null, mesa ? null # OpenGL (required for vwebp)
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

assert openglSupport -> ((freeglut != null) && (mesa != null));
assert pngSupport -> (libpng != null);
assert jpegSupport -> (libjpeg != null);
assert tiffSupport -> (libtiff != null);
assert gifSupport -> (giflib != null);

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libwebp-${version}";
  version = "0.4.3";

  src = fetchurl {
    url = "http://downloads.webmproject.org/releases/webp/${name}.tar.gz";
    sha256 = "1i4hfczjm3b1qj1g4cc9hgb69l47f3nkgf6hk7nz4dm9zmc0vgpg";
  };

  configureFlags = [
    (mkEnable threadingSupport "threading" null)
    (mkEnable openglSupport "gl" null)
    (mkEnable pngSupport "png" null)
    (mkEnable jpegSupport "jpeg" null)
    (mkEnable tiffSupport "tiff" null)
    (mkEnable gifSupport "gif" null)
    #(mkEnable (wicSupport && stdenv.isCygwin) "wic" null)
    (mkEnable alignedSupport "aligned" null)
    (mkEnable swap16bitcspSupport "swap-16bit-csp" null)
    (mkEnable experimentalSupport "experimental" null)
    (mkEnable libwebpmuxSupport "libwebpmux" null)
    (mkEnable libwebpdemuxSupport "libwebpdemux" null)
    (mkEnable libwebpdecoderSupport "libwebpdecoder" null)
  ];

  buildInputs = [ ]
    ++ optionals openglSupport [ freeglut mesa ]
    ++ optional pngSupport libpng
    ++ optional jpegSupport libjpeg
    ++ optional tiffSupport libtiff
    ++ optional gifSupport giflib;

  meta = {
    description = "Tools and library for the WebP image format";
    homepage = https://developers.google.com/speed/webp/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ codyopel ];
  };
}
