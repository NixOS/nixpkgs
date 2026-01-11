{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlink";
  version = "0-unstable-2025-14-03";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "XLink";
    rev = "fe8b5450f545a2ebf26dbc093e98c0265d7f4029";
    hash = "sha256-OTqJfTDudiNrdsDBe1Pg0T1dJcfneGXO/+AIbXpVfxk=";
  };

  outputs = [
    "out"
    "share"
  ];

  # Remove CMake Hunter package manager - needs network connection
  patches = [
    ./001-remove-hunter.patch
    # Bump CMakeLists.txt to 3.10
    (fetchpatch {
      url = "https://github.com/luxonis/XLink/commit/160c6c918c07e28a6a8c5c080a257f7619223304.patch?full_index=1";
      hash = "sha256-1VMCteJf/an20fI3UTT/X9cH96dCxPRQolfN+e+6jnU=";
    })
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
      "multiple_open_stream"
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
    maintainers = with lib.maintainers; [ phodina ];
  };
})
