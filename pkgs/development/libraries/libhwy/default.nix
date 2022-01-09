{ lib, stdenv, cmake, ninja, gtest, fetchpatch, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    sha256 = "sha256-v2HyyHtBydr7QiI83DW1yRv2kWjUOGxFT6mmdrN9XPo=";
  };

  patches = [
    # Remove on next release
    # https://github.com/google/highway/issues/460
    (fetchpatch {
      name = "hwy-add-missing-includes.patch";
      url = "https://github.com/google/highway/commit/8ccab40c2f931aca6004d175eec342cc60f6baec.patch";
      sha256 = "sha256-wlp5gIvK2+OlKtsZwxq/pXTbESkUtimHXaYDjcBzmQ0=";
    })
  ];

  nativeBuildInputs = [ cmake ninja ];

  checkInputs = [ gtest ];

  # Required for case-insensitive filesystems ("BUILD" exists)
  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optional doCheck "-DHWY_SYSTEM_GTEST:BOOL=ON";

  # hydra's darwin machines run into https://github.com/libjxl/libjxl/issues/408
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
