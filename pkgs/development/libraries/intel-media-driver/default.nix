{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, libva
, libpciaccess
, intel-gmmlib
, libdrm
, enableX11 ? stdenv.isLinux
, libX11
}:

stdenv.mkDerivation rec {
  pname = "intel-media-driver";
  version = "22.5.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "media-driver";
    rev = "intel-media-${version}";
    sha256 = "sha256-8E3MN4a+k8YA+uuUPApYFvT82bgJHE1cnPyuAO6R1tA=";
  };

  patches = [
    # fix platform detection
    (fetchpatch {
      url = "https://salsa.debian.org/multimedia-team/intel-media-driver-non-free/-/raw/master/debian/patches/0002-Remove-settings-based-on-ARCH.patch";
      sha256 = "sha256-f4M0CPtAVf5l2ZwfgTaoPw7sPuAP/Uxhm5JSHEGhKT0=";
    })
    # fix compilation on i686-linux
    (fetchpatch {
      url = "https://github.com/intel/media-driver/commit/5ee502b84eb70f0d677a3b49d624c356b3f0c2b1.patch";
      revert = true;
      sha256 = "sha256-yRS10BKD5IkW8U0PxmyB7ryQiLwrqeetm0NivnoM224=";
    })
  ];

  cmakeFlags = [
    "-DINSTALL_DRIVER_SYSCONF=OFF"
    "-DLIBVA_DRIVERS_PATH=${placeholder "out"}/lib/dri"
    # Works only on hosts with suitable CPUs.
    "-DMEDIA_RUN_TEST_SUITE=OFF"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.hostPlatform.system == "i686-linux") "-D_FILE_OFFSET_BITS=64";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libva libpciaccess intel-gmmlib libdrm ]
    ++ lib.optional enableX11 libX11;

  postFixup = lib.optionalString enableX11 ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/lib/dri/iHD_drv_video.so):${lib.makeLibraryPath [ libX11 ]}" \
      $out/lib/dri/iHD_drv_video.so
  '';

  meta = with lib; {
    description = "Intel Media Driver for VAAPI — Broadwell+ iGPUs";
    longDescription = ''
      The Intel Media Driver for VAAPI is a new VA-API (Video Acceleration API)
      user mode driver supporting hardware accelerated decoding, encoding, and
      video post processing for GEN based graphics hardware.
    '';
    homepage = "https://github.com/intel/media-driver";
    changelog = "https://github.com/intel/media-driver/releases/tag/intel-media-${version}";
    license = with licenses; [ bsd3 mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau SuperSandro2000 ];
  };
}
