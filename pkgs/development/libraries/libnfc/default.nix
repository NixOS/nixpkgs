{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, libusb-compat-0_1
, readline
, cmake
, pkg-config
, static ? false
}:

stdenv.mkDerivation rec {
  pname = "libnfc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = pname;
    rev = "libnfc-${version}";
    sha256 = "5gMv/HajPrUL/vkegEqHgN2d6Yzf01dTMrx4l34KMrQ=";
  };

  patches = [
    # From: https://github.com/nfc-tools/libnfc/pull/595
    (fetchpatch {
      name = "libnfc-Enable-selection-of-static-vs-shared-builds.patch";
      url = "https://github.com/kino-dome/libnfc/commit/992f1c56ca7663357911c24843834a88ef98d8dc.patch";
      hash = "sha256:1q74nylxpmbw3iqxdi24kra4bfx7gjx1v0i0nzb1jkpp15580hp1";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb-compat-0_1
    readline
  ];

  configureFlags = [
    "sysconfdir=/etc"
  ];

  cmakeFlags = lib.concatLists [
    (lib.optionals stdenv.isDarwin [
      "-DLIBNFC_DRIVER_PN532_I2C=OFF"
      "-DLIBNFC_DRIVER_PN532_SPI=OFF"
    ])
    (lib.optional (!static) "-DBUILD_SHARED_LIBS:BOOL=ON")
  ];

  meta = with lib; {
    description = "Library for Near Field Communication (NFC)";
    homepage = "https://github.com/nfc-tools/libnfc";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
