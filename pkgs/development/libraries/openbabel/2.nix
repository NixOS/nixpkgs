{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  zlib,
  libxml2,
  eigen,
  python3,
  cairo,
  pcre,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "openbabel";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "openbabel";
    repo = "openbabel";
    rev = "openbabel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-+pXsWMzex7rB1mm6dnTHzAcyw9jImgx1OZuLeCvbeJ0=";
  };

  patches = [
    # ARM / AArch64 fixes.
    (fetchpatch {
      url = "https://github.com/openbabel/openbabel/commit/ee11c98a655296550710db1207b294f00e168216.patch";
      sha256 = "0wjqjrkr4pfirzzicdvlyr591vppydk572ix28jd2sagnfnf566g";
    })
  ];

  postPatch = ''
    sed '1i#include <ctime>' -i include/openbabel/obutil.h # gcc12
  '';

  buildInputs = [
    zlib
    libxml2
    eigen
    python3
    cairo
    pcre
  ];

  cmakeFlags = [ "-DCMAKE_CXX_STANDARD=14" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "Toolbox designed to speak the many languages of chemical data";
    homepage = "http://openbabel.org";
    platforms = platforms.all;
    maintainers = with maintainers; [ danielbarter ];
    license = licenses.gpl2Plus;
  };
}
