{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlink";
  version = "0-unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "XLink";
    rev = "f001d710be6a4010db913510da08caaa3a58466c";
    hash = "sha256-5EJtspMCasIMeJGITiU4KRfH9rAYqWlyGm29fNnwGUI=";
  };

  outputs = [
    "out"
    "share"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
  ];

  cmakeFlags = [
    (lib.cmakeBool "XLINK_ENABLE_LIBUSB" true)
    (lib.cmakeBool "XLINK_BUILD_EXAMPLES" true)
    (lib.cmakeBool "XLINK_BUILD_TESTS" true)
    (lib.cmakeBool "XLINK_LIBUSB_SYSTEM" true)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
  ];

  postInstall = ''
    mkdir -p $out/include
    mkdir -p $share/examples
    mkdir -p $share/tests

    cp -r $src/include/* $out/include/

    examples=(
      "boot_firmware"
      "list_devices"
      "boot_bootloader"
      "search_devices"
      "Makefile"
      "device_connect_reset"
    )

    tests=(
      "multithreading_search_test"
    )

    find $buildDir
    for file in "''${examples[@]}"; do
      cp examples/$file $share/examples/$file
    done
    for file in "''${tests[@]}"; do
      cp tests/$file $share/tests/$file
    done
  '';

  meta = {
    description = "Library for communication with Myriad VPUs";
    homepage = "https://github.com/luxonis/XLink";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      amronos
      phodina
    ];
  };
})
