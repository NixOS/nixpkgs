{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "zxing-cpp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "nu-book";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-atBHqwLGrSZmv5KSZqBu7N8N1PODvAhhxvRZA0mENt0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BLACKBOX_TESTS=OFF"
  ];

  passthru.tests = {
    inherit (python3.pkgs) zxing_cpp;
  };

  meta = with lib; {
    homepage = "https://github.com/nu-book/zxing-cpp";
    description = "C++ port of zxing (a Java barcode image processing library)";
    longDescription = ''
      ZXing-C++ ("zebra crossing") is an open-source, multi-format 1D/2D barcode
      image processing library implemented in C++.

      It was originally ported from the Java ZXing Library but has been
      developed further and now includes many improvements in terms of quality
      and performance. It can both read and write barcodes in a number of
      formats.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
