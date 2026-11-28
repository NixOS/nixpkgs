{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  cmake,
  nceplibs-g2c,
  libaec,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wgrib2";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "NOAA-EMC";
    repo = "wgrib2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zr+aAtZ4VzFQxjTCJqWg/ZIp1p8r9mSzeS0VSB3u2TM=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    nceplibs-g2c
    libaec
  ];
  cmakeFlags = [
    # Enable support for JPEG2000 and PNG compression.
    "-DUSE_G2CLIB_LOW=ON"
    # Enable support for AEC compression.
    "-DUSE_AEC=ON"
  ];

  meta = {
    description = "Provides functionality for interacting with, reading, writing, and manipulating GRIB2 files";
    homepage = "https://github.com/NOAA-EMC/wgrib2";
    longDescription = ''
      Wgrib2 is a processor for grib2 files. It is a utility and library for
      manipulating grib files, The utility was designed to be used to reduce the
      need for custom Fortran programs to read, write and manipulate grib files.
    '';
    platforms = lib.platforms.unix;
    mainProgram = "wgrib2";
    maintainers = [ lib.maintainers.kqr ];
  };
})
