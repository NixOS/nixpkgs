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
  pname = "${ipu6-camera-bin.ipuVersion}-camera-hal";
  version = "unstable-2023-02-08";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-hal";
    rev = "884b81aae0ea19a974eb8ccdaeef93038136bdd4";
    hash = "sha256-AePL7IqoOhlxhfPRLpCman5DNh3wYS4MUcLgmgBUcCM=";
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

  postPatch = ''
    substituteInPlace src/platformdata/PlatformData.h \
      --replace '/usr/share/' "${placeholder "out"}/share/"
  '';

  postFixup = ''
    substituteInPlace $out/lib/pkgconfig/libcamhal.pc \
      --replace 'prefix=/usr' "prefix=$out"
  '';

  passthru = {
    inherit (ipu6-camera-bin) ipuVersion;
  };

  meta = with lib; {
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu6-camera-hal";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
    platforms = [ "x86_64-linux" ];
  };
}
