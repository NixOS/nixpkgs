{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  python3,
  stdenv,
  libzint,
  pkg-config,
  stb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zxing-cpp";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "zxing-cpp";
    repo = "zxing-cpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dCqn2qYQGHY/nmwwkgd4uGoKp0YeQxWiHpS0Hhsm+UE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libzint
    stb
  ];

  cmakeFlags = [
    "-DZXING_BLACKBOX_TESTS=OFF"
    "-DZXING_DEPENDENCIES=LOCAL"
    "-DZXING_EXAMPLES=OFF"
    "-DZXING_USE_BUNDLED_ZINT=OFF"
    (lib.cmakeFeature "ZXING_WRITERS" "BOTH")
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
    maintainers = with lib.maintainers; [
      lukegb
      qweered
    ];
    platforms = lib.platforms.unix;
  };
})
