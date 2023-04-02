{ lib
, stdenv
, fetchFromGitHub

# build
, cmake
, pkg-config

# runtime
, expat
, ipu6-camera-bin
, libtool
, gst_all_1
}:

stdenv.mkDerivation {
  pname = "ipu6-camera-hal";
  version = "unstable-2023-01-09";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-hal";
    rev = "37292891c73367d22ba1fc96ea9b6e4546903037";
    hash = "sha256-dJvTZt85rt5/v2JXOsfbSY933qffyXW74L0nWdIlqug=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DIPU_VER=${ipu6-camera-bin.ipuVersion}"
    # missing libiacss
    "-DUSE_PG_LITE_PIPE=ON"
    # missing libipu4
    "-DENABLE_VIRTUAL_IPU_PIPE=OFF"
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${lib.getDev ipu6-camera-bin}/include/ia_imaging"
    "-I${lib.getDev ipu6-camera-bin}/include/ia_camera"
  ];

  enableParallelBuilding = true;

  buildInputs = [
    expat
    ipu6-camera-bin
    libtool
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  preFixup = ''
    ls -lah $out/lib/pkgconfig/
    sed -Ei \
      -e "s,^prefix=.*,prefix=$out," \
      -e "s,^exec_prefix=.*,exec_prefix=''${prefix}," \
      -e "s,^libdir=.*,libdir=''${prefix}/lib," \
      -e "s,^includedir=.*,includedir=''${prefix}/include/libcamhal," \
      $out/lib/pkgconfig/libcamhal.pc
  '';

  meta = with lib; {
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu6-camera-hal";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
    platforms = [ "x86_64-linux" ];
  };
}
