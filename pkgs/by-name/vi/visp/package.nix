{
  cmake,
  coin3d,
  doxygen,
  eigen,
  fetchFromGitHub,
  fetchpatch,
  lapack,
  lib,
  libdc1394,
  libdmtx,
  libglvnd,
  libjpeg, # this is libjpeg-turbo
  libpng,
  librealsense,
  libxml2,
  libX11,
  nlohmann_json,
  #ogre,
  openblas,
  opencv,
  pkg-config,
  python3Packages,
  stdenv,
  texliveSmall,
  v4l-utils,
  xorg,
  zbar,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "visp";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "lagadic";
    repo = "visp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m5Tmr+cZab7eSjmbXb8HpJpFHb0UYFTyimY+CkfBIAo=";
  };

  patches = [
    # fix for absolute install paths
    # this was merged upstream, and can be removed on next release
    (fetchpatch {
      url = "https://github.com/lagadic/visp/pull/1416/commits/fdda5620389badee998fe1926ddd3b46f7a6bcd8.patch";
      hash = "sha256-W3vvBdQdp59WAMjuucNoWI0eCyPHjWerl7VCNcPVvzI=";
    })

    # fix for opencv new Universal Intrinsic API
    # this was merged upstream, and can be removed on next release
    (fetchpatch {
      url = "https://github.com/lagadic/visp/pull/1310/commits/9ed0300507e13dddd83fd62a799f5039025ea44e.patch";
      hash = "sha256-xrJ7B/8mEfi9dM/ToMr6vCAwX/FMw+GA/W0zFYgT32s=";
    })

    # fix error: unsupported option '-mfpu=' on darwin
    # this was merged upstream, and can be removed on next release
    (fetchpatch {
      url = "https://github.com/lagadic/visp/commit/8c1461661f99a5db31c89ede9946d2b0244f8123.patch";
      hash = "sha256-MER5KDrFxKs+Y5G9UcEIAh95Zilmv1Vp4xq+isRMM/U=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    texliveSmall
  ];

  buildInputs = [
    eigen
    lapack
    libdc1394
    libdmtx
    libglvnd
    libjpeg
    libpng
    librealsense
    libX11
    libxml2
    nlohmann_json
    #ogre
    openblas
    opencv
    python3Packages.numpy
    xorg.libpthreadstubs
    zbar
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    coin3d
    v4l-utils
  ];

  doCheck = true;

  meta = {
    description = "Open Source Visual Servoing Platform";
    # ref. https://github.com/lagadic/visp/pull/1658
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
    homepage = "https://visp.inria.fr";
    changelog = "https://github.com/lagadic/visp/blob/v${finalAttrs.version}/ChangeLog.txt";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
