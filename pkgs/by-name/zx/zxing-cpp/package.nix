{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  python3,
  stdenv,
  libzint,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zxing-cpp";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "zxing-cpp";
    repo = "zxing-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3nSxjg8p+1DEUbZOh4C2zfnA6iGhNJMPiIe2oJEbRo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libzint
  ];

  cmakeFlags = [
    "-DZXING_BLACKBOX_TESTS=OFF"
    "-DZXING_DEPENDENCIES=LOCAL"
    "-DZXING_EXAMPLES=OFF"
    "-DZXING_USE_BUNDLED_ZINT=OFF"
  ];

  passthru = {
    tests = {
      inherit (python3.pkgs) zxing-cpp;
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    homepage = "https://github.com/zxing-cpp/zxing-cpp";
    changelog = "https://github.com/zxing-cpp/zxing-cpp/releases/tag/${finalAttrs.src.rev}";
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
    maintainers = with lib.maintainers; [ lukegb ];
    platforms = lib.platforms.unix;
  };
})
