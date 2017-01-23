{ lib, stdenv, fetchurl, fetchpatch, fetchFromGitHub, cmake, pkgconfig, unzip
, zlib
, enableIpp ? false
, enableContrib ? false
, enablePython ? false, pythonPackages
, enableGtk2 ? false, gtk2
, enableGtk3 ? false, gtk3
, enableJPEG ? true, libjpeg
, enablePNG ? true, libpng
, enableTIFF ? true, libtiff
, enableWebP ? true, libwebp
, enableEXR ? true, openexr, ilmbase
, enableJPEG2K ? true, jasper
, enableFfmpeg ? false, ffmpeg
, enableGStreamer ? false, gst_all_1
, enableEigen ? false, eigen
, enableCuda ? false, cudatoolkit, gcc5
}:

let
  version = "3.1.0";

  contribSrc = fetchFromGitHub {
    owner = "Itseez";
    repo = "opencv_contrib";
    rev = version;
    sha256 = "153yx62f34gl3zd6vgxv0fj3wccwmq78lnawlda1f6xhrclg9bax";
  };

  opencvFlag = name: enabled: "-DWITH_${name}=${if enabled then "ON" else "OFF"}";

in

stdenv.mkDerivation rec {
  name = "opencv-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "Itseez";
    repo = "opencv";
    rev = version;
    sha256 = "1l0w12czavgs0wzw1c594g358ilvfg2fn32cn8z7pv84zxj4g429";
  };

  patches =
    lib.optionals enableCuda [
      (fetchpatch { # Patch for CUDA 8 compatibility
        url = "https://github.com/opencv/opencv/commit/10896129b39655e19e4e7c529153cb5c2191a1db.patch";
        sha256 = "0jka3kxxywgs3prqqgym5kav6p73rrblwj50k1nf3fvfpk194ah1";
      })
      (fetchpatch { # Patch to add CUDA Compute Capability compilation targets up to 6.0
        url = "https://github.com/opencv/opencv/commit/d76f258aebdf63f979a205cabe6d3e81700a7cd8.patch";
        sha256 = "00b3msfgrcw7laij6qafn4b18c1dl96xxpzwx05wxzrjldqb6kqg";
      })
    ]
    ++ lib.optional enablePython (fetchpatch { # Patch to fix FlannBasedMatcher under python
      url = "https://github.com/opencv/opencv/commit/05cfe28612fd8dc8fb0ccb876df945c7b435dd26.patch";
      sha256 = "0niza5lybr1ljzdkyiapr16laa468168qinpy5qn00yimnaygpm6";
    });

  preConfigure =
    # By default ippicv gets downloaded by cmake each time opencv is build. See:
    # https://github.com/opencv/opencv/blob/3.1.0/3rdparty/ippicv/downloader.cmake
    # Fortunately cmake doesn't download ippicv if it's already there.
    # So to prevent repeated downloads we store it in the nix store
    # and create a symbolic link to it.
    let version  = "20151201";
        md5      = "808b791a6eac9ed78d32a7666804320e";
        sha256   = "1nph0w0pdcxwhdb5lxkb8whpwd9ylvwl97hn0k425amg80z86cs3";
        rev      = "81a676001ca8075ada498583e4166079e5744668";
        platform = if stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux" then "linux"
                   else throw "ICV is not available for this platform (or not yet supported by this package)";
        name = "ippicv_${platform}_${version}.tgz";
        ippicv = fetchurl {
          url = "https://raw.githubusercontent.com/opencv/opencv_3rdparty/${rev}/ippicv/${name}";
          inherit sha256;
        };
        dir = "3rdparty/ippicv/downloads/${platform}-${md5}";
    in lib.optionalString enableIpp
      ''
        mkdir -p "${dir}"
        ln -s "${ippicv}" "${dir}/${name}"
      '';

  buildInputs =
       [ zlib ]
    ++ lib.optional enablePython pythonPackages.python
    ++ lib.optional enableGtk2 gtk2
    ++ lib.optional enableGtk3 gtk3
    ++ lib.optional enableJPEG libjpeg
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableTIFF libtiff
    ++ lib.optional enableWebP libwebp
    ++ lib.optionals enableEXR [ openexr ilmbase ]
    ++ lib.optional enableJPEG2K jasper
    ++ lib.optional enableFfmpeg ffmpeg
    ++ lib.optionals enableGStreamer (with gst_all_1; [ gstreamer gst-plugins-base ])
    ++ lib.optional enableEigen eigen
    ++ lib.optional enableCuda [ cudatoolkit gcc5 ]
    ;

  propagatedBuildInputs = lib.optional enablePython pythonPackages.numpy;

  nativeBuildInputs = [ cmake pkgconfig unzip ];

  NIX_CFLAGS_COMPILE = lib.optional enableEXR "-I${ilmbase.dev}/include/OpenEXR";

  cmakeFlags = [
    "-DWITH_IPP=${if enableIpp then "ON" else "OFF"}"
    (opencvFlag "TIFF" enableTIFF)
    (opencvFlag "JASPER" enableJPEG2K)
    (opencvFlag "WEBP" enableWebP)
    (opencvFlag "JPEG" enableJPEG)
    (opencvFlag "PNG" enablePNG)
    (opencvFlag "OPENEXR" enableEXR)
    (opencvFlag "CUDA" enableCuda)
    (opencvFlag "CUBLAS" enableCuda)
  ] ++ lib.optionals enableContrib [ "-DOPENCV_EXTRA_MODULES_PATH=${contribSrc}/modules" ]
    ++ lib.optionals enableCuda [ "-DCUDA_FAST_MATH=ON" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "bindnow" "relro" ];

  passthru = lib.optionalAttrs enablePython { pythonPath = []; };

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric flosse mdaiter];
    platforms = with stdenv.lib.platforms; linux;
  };
}
