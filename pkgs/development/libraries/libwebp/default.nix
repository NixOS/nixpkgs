{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  threadingSupport ? true, # multi-threading
  openglSupport ? false,
  freeglut,
  libGL,
  libGLU, # OpenGL (required for vwebp)
  pngSupport ? true,
  libpng, # PNG image format
  jpegSupport ? true,
  libjpeg, # JPEG image format
  tiffSupport ? true,
  libtiff, # TIFF image format
  gifSupport ? true,
  giflib, # GIF image format
  alignedSupport ? false, # Force aligned memory operations
  swap16bitcspSupport ? false, # Byte swap for 16bit color spaces
  experimentalSupport ? false, # Experimental code
  libwebpmuxSupport ? true, # Build libwebpmux
  libwebpdemuxSupport ? true, # Build libwebpdemux
  libwebpdecoderSupport ? true, # Build libwebpdecoder

  # for passthru.tests
  freeimage,
  gd,
  graphicsmagick,
  haskellPackages,
  imagemagick,
  imlib2,
  libjxl,
  opencv,
  python3,
  vips,
}:

stdenv.mkDerivation rec {
  pname = "libwebp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OR/VzKNn3mnwjf+G+RkEGAaaKrhVlAu1e2oTRwdsPj8=";
  };

  configureFlags = [
    (lib.enableFeature threadingSupport "threading")
    (lib.enableFeature openglSupport "gl")
    (lib.enableFeature pngSupport "png")
    (lib.enableFeature jpegSupport "jpeg")
    (lib.enableFeature tiffSupport "tiff")
    (lib.enableFeature gifSupport "gif")
    (lib.enableFeature alignedSupport "aligned")
    (lib.enableFeature swap16bitcspSupport "swap-16bit-csp")
    (lib.enableFeature experimentalSupport "experimental")
    (lib.enableFeature libwebpmuxSupport "libwebpmux")
    (lib.enableFeature libwebpdemuxSupport "libwebpdemux")
    (lib.enableFeature libwebpdecoderSupport "libwebpdecoder")
  ];

  nativeBuildInputs = [
    autoreconfHook
    libtool
  ];
  buildInputs =
    [ ]
    ++ lib.optionals openglSupport [
      freeglut
      libGL
      libGLU
    ]
    ++ lib.optionals pngSupport [ libpng ]
    ++ lib.optionals jpegSupport [ libjpeg ]
    ++ lib.optionals tiffSupport [ libtiff ]
    ++ lib.optionals gifSupport [ giflib ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit
      gd
      graphicsmagick
      imagemagick
      imlib2
      libjxl
      opencv
      vips
      ;
    inherit (python3.pkgs) pillow imread;
    haskell-webp = haskellPackages.webp;
  };

  meta = with lib; {
    description = "Tools and library for the WebP image format";
    homepage = "https://developers.google.com/speed/webp/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ajs124 ];
  };
}
