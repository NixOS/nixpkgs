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
  version = "unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu6-camera-hal";
    rev = "c933525a6efe8229a7129b7b0b66798f19d2bef7";
    hash = "sha256-ZWwszteRmUBn0wGgN5rmzw/onfzBoPGadcmpk+93kAM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DBUILD_CAMHAL_ADAPTOR=ON"
    "-DBUILD_CAMHAL_PLUGIN=ON"
    "-DIPU_VERSIONS=${ipuVersion}"
    "-DUSE_PG_LITE_PIPE=ON"
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
