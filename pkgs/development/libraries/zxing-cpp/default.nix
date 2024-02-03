{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, python3
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zxing-cpp";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "zxing-cpp";
    repo = "zxing-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B/jGsHImRfj0iEio2b6R6laWBI1LL3OI407O7sren8s=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BLACKBOX_TESTS=OFF"
  ];

  passthru = {
    tests = {
      inherit (python3.pkgs) zxing_cpp;
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    homepage = "https://github.com/zxing-cpp/zxing-cpp";
    description = "C++ port of zxing (a Java barcode image processing library)";
    longDescription = ''
      ZXing-C++ ("zebra crossing") is an open-source, multi-format 1D/2D barcode
      image processing library implemented in C++.

      It was originally ported from the Java ZXing Library but has been
      developed further and now includes many improvements in terms of quality
      and performance. It can both read and write barcodes in a number of
      formats.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ AndersonTorres lukegb ];
    platforms = lib.platforms.unix;
  };
})
