{ lib, stdenv, fetchurl, cmake, gtk, libjpeg, libpng, libtiff, jasper, ffmpeg
, fetchpatch, pkgconfig, gstreamer, xineLib, glib, python27, python27Packages, unzip
, enableIpp ? false
, enableBloat ? false }:

let v = "3.0.0"; in

stdenv.mkDerivation rec {
  name = "opencv-${v}";

  src = fetchurl {
    url = "https://github.com/Itseez/opencv/archive/${v}.zip";
    sha256 = "00dh7wvgkflz22liqd10fma8m3395lb3l3rgawnn5wlnz6i4w287";
  };

  postPatch =
    let ippicv = fetchurl {
          url = "http://sourceforge.net/projects/opencvlibrary/files/3rdparty/ippicv/${ippicvName}";
          md5 = ippicvHash;
        };
        ippicvName    = "ippicv_linux_20141027.tgz";
        ippicvHash    = "8b449a536a2157bcad08a2b9f266828b";
        ippicvArchive = "3rdparty/ippicv/downloads/linux-${ippicvHash}/${ippicvName}";
    in stdenv.lib.optionalString enableIpp
      ''
        mkdir -p $(dirname ${ippicvArchive})
        ln -s ${ippicv}    ${ippicvArchive}
      '';

  buildInputs =
    [ unzip libjpeg libpng libtiff ]
    ++ lib.optionals enableBloat [ gtk glib jasper ffmpeg xineLib gstreamer python27 python27Packages.numpy ];

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [ "-DWITH_IPP=${if enableIpp then "ON" else "OFF"}" ];

  enableParallelBuilding = true;

  meta = {
    description = "Open Computer Vision Library with more than 500 algorithms";
    homepage = http://opencv.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [viric flosse];
    platforms = with stdenv.lib.platforms; linux;
  };
}
