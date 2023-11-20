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

# Pick one of
# - ipu6 (Tiger Lake)
# - ipu6ep (Alder Lake)
# - ipu6epmtl (Meteor Lake)
, ipuVersion ? "ipu6"
}:
let
  ipuTarget = {
    "ipu6" = "ipu_tgl";
    "ipu6ep" = "ipu_adl";
    "ipu6epmtl" = "ipu_mtl";
  }.${ipuVersion};
in
stdenv.mkDerivation {
  pname = "${ipuVersion}-camera-hal";
  version = "unstable-2023-09-25";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-hal";
    rev = "9fa05a90886d399ad3dda4c2ddc990642b3d20c9";
    hash = "sha256-yS1D7o6dsQ4FQkjfwcisOxcP7Majb+4uQ/iW5anMb5c=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  PKG_CONFIG_PATH = "${lib.getDev ipu6-camera-bin}/lib/${ipuTarget}/pkgconfig";

  cmakeFlags = [
    "-DIPU_VER=${ipuVersion}"
    # missing libiacss
    "-DUSE_PG_LITE_PIPE=ON"
    # missing libipu4
    "-DENABLE_VIRTUAL_IPU_PIPE=OFF"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
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
    inherit ipuVersion;
  };

  meta = with lib; {
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu6-camera-hal";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
    platforms = [ "x86_64-linux" ];
  };
}
