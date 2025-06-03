{
  lib,
  stdenv,
  fetchFromGitHub,

  # build
  cmake,
  pkg-config,

  # runtime
  expat,
  ipu6-camera-bins,
  libtool,
  gst_all_1,
  libdrm,

  # Pick one of
  # - ipu6 (Tiger Lake)
  # - ipu6ep (Alder Lake)
  # - ipu6epmtl (Meteor Lake)
  ipuVersion ? "ipu6",
}:
let
  ipuTarget =
    {
      "ipu6" = "ipu_tgl";
      "ipu6ep" = "ipu_adl";
      "ipu6epmtl" = "ipu_mtl";
    }
    .${ipuVersion};
in
stdenv.mkDerivation {
  pname = "${ipuVersion}-camera-hal";
  version = "unstable-2024-09-29";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-hal";
    rev = "f98f72b156563fe8373e4f8d017a9f609676bb33";
    hash = "sha256-zVcgKW7/GHYd1oMvsaI77cPyj3G68dL+OXBJDz5+Td4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DIPU_VER=${ipuVersion}"
    "-DTARGET_SUFFIX=-${ipuVersion}"
    # missing libiacss
    "-DUSE_PG_LITE_PIPE=ON"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_SUB_PATH=${ipuTarget}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error"
  ];

  enableParallelBuilding = true;

  buildInputs = [
    expat
    ipu6-camera-bins
    libtool
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libdrm
  ];

  postPatch = ''
    substituteInPlace src/platformdata/PlatformData.h \
      --replace '/usr/share/' "${placeholder "out"}/share/" \
      --replace '#define CAMERA_DEFAULT_CFG_PATH "/etc/camera/"' '#define CAMERA_DEFAULT_CFG_PATH "${placeholder "out"}/etc/camera/"'
  '';

  postInstall = ''
    mkdir -p $out/include/${ipuTarget}/
    cp -r $src/include $out/include/${ipuTarget}/libcamhal
  '';

  postFixup = ''
    for lib in $out/lib/*.so; do
      patchelf --add-rpath "${ipu6-camera-bins}/lib" $lib
    done
  '';

  passthru = {
    inherit ipuVersion ipuTarget;
  };

  meta = with lib; {
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu6-camera-hal";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
