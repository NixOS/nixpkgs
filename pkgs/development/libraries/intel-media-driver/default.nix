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
  # for passhtru.tests
, pkgsi686Linux
}:

stdenv.mkDerivation rec {
  pname = "intel-media-driver";
  version = "23.1.6";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "media-driver";
    rev = "intel-media-${version}";
    sha256 = "sha256-Z1xBU+4SdwknXpYUS8EwEURNIsg2+R/U0CcW3FW325M=";
  };

  patches = [
    # fix platform detection
    (fetchpatch {
      url = "https://salsa.debian.org/multimedia-team/intel-media-driver-non-free/-/raw/04ffb03f744780a55aba311c612d708b00584bb7/debian/patches/0002-Remove-settings-based-on-ARCH.patch";
      sha256 = "sha256-o/Pg0S53SYh3O7L+AwxOPl1Bx4TS6iKB8ql8GhhHI/o=";
    })
  ];

  cmakeFlags = [
    "-DINSTALL_DRIVER_SYSCONF=OFF"
    "-DLIBVA_DRIVERS_PATH=${placeholder "out"}/lib/dri"
    # Works only on hosts with suitable CPUs.
    "-DMEDIA_RUN_TEST_SUITE=OFF"
    "-DMEDIA_BUILD_FATAL_WARNINGS=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.hostPlatform.system == "i686-linux") "-D_FILE_OFFSET_BITS=64";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libva libpciaccess intel-gmmlib libdrm ]
    ++ lib.optional enableX11 libX11;

  postFixup = lib.optionalString enableX11 ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/lib/dri/iHD_drv_video.so):${lib.makeLibraryPath [ libX11 ]}" \
      $out/lib/dri/iHD_drv_video.so
  '';

  passthru.tests = {
    inherit (pkgsi686Linux) intel-media-driver;
  };

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
