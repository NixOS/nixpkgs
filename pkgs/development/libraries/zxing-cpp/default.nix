{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "zxing-cpp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nu-book";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MTu8tvJXpo6+Z0aSIZ27nmerNtNBOwnL/jDkGedIiM8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BLACKBOX_TESTS=OFF"
  ];

  # https://github.com/nu-book/zxing-cpp/issues/335
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'configure_file(zxing.pc.in' \
                'include(GNUInstallDirs)
                 configure_file(zxing.pc.in'
    substituteInPlace zxing.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

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
