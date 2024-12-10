{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  git,
  asio,
  catch2,
  spdlog,
  IOKit,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "pc-ble-driver";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-srH7Gdiy9Lsv68fst/9jhifx03R2e+4kMia6pU/oCZg=";
  };

  patches = [
    (fetchpatch {
      name = "support-arm.patch";
      url = "https://github.com/NordicSemiconductor/pc-ble-driver/commit/76a6b31dba7a13ceae40587494cbfa01a29192f4.patch";
      hash = "sha256-bvK1BXjdlhIXV8R4PiCGaq8oSLzgjMmTgAwssm8N2sk=";
    })
    # Fix build with GCC 11
    (fetchpatch {
      url = "https://github.com/NordicSemiconductor/pc-ble-driver/commit/37258e65bdbcd0b4369ae448faf650dd181816ec.patch";
      hash = "sha256-gOdzIW8YJQC+PE4FJd644I1+I7CMcBY8wpF6g02eI5g=";
    })
  ];

  cmakeFlags =
    [
      "-DNRF_BLE_DRIVER_VERSION=${version}"
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      "-DARCH=arm64"
    ];

  nativeBuildInputs = [
    cmake
    git
  ];
  buildInputs = [
    asio
    catch2
    spdlog
  ];

  propagatedBuildInputs =
    [

    ]
    ++ lib.optionals stdenv.isDarwin [
      IOKit
    ]
    ++ lib.optionals stdenv.isLinux [
      udev
    ];

  meta = with lib; {
    description = "Desktop library for Bluetooth low energy development";
    homepage = "https://github.com/NordicSemiconductor/pc-ble-driver";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
  };
}
