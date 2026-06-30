{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  python3,
  stdenv,
  libzint,
  stb,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zxing-cpp";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "zxing-cpp";
    repo = "zxing-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZtjvHBnuPJkc9kU998jH7IPlX3jF/RGtLNWDzsb0v4A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    stb
  ];

  buildInputs = [
    libzint
  ];

  cmakeFlags = [
    "-DZXING_BLACKBOX_TESTS=OFF"
    "-DZXING_DEPENDENCIES=LOCAL"
    "-DZXING_EXAMPLES=ON"
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
