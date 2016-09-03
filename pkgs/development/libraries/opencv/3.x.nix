{ lib, stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig, unzip
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

  postPatch =
    let ippicvVersion = "20151201";
        ippicvPlatform = if stdenv.system == "x86_64-linux" || stdenv.system == "i686-linux" then "linux"
                         else throw "ICV is not available for this platform (or not yet supported by this package)";
        ippicvHash = if ippicvPlatform == "linux" then "808b791a6eac9ed78d32a7666804320e"
                     else throw "ippicvHash: impossible";

        ippicvName = "ippicv_${ippicvPlatform}_${ippicvVersion}.tgz";
        ippicvArchive = "3rdparty/ippicv/downloads/linux-${ippicvHash}/${ippicvName}";
        ippicv = fetchurl {
          url = "https://github.com/Itseez/opencv_3rdparty/raw/ippicv/master_${ippicvVersion}/ippicv/${ippicvName}";
          md5 = ippicvHash;
        };
    in lib.optionalString enableIpp
      ''
        mkdir -p $(dirname ${ippicvArchive})
        ln -s ${ippicv}    ${ippicvArchive}
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
  ] ++ lib.optionals enableContrib [ "-DOPENCV_EXTRA_MODULES_PATH=${contribSrc}/modules" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "bindnow" "relro" ];

  passthru = lib.optionalAttrs enablePython { pythonPath = []; };

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric flosse];
    platforms = with stdenv.lib.platforms; linux;
  };
}
