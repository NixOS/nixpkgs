{ lib
, stdenv
, fetchgit
, cmake
, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "libyuv";
  version = "1787"; # Defined in: include/libyuv/version.h

  src = fetchgit {
    url = "https://chromium.googlesource.com/libyuv/libyuv.git";
    rev = "eb6e7bb63738e29efd82ea3cf2a115238a89fa51"; # refs/heads/stable
    sha256 = "sha256-DtRYoaAXb9ZD2OLiKbzKzH5vzuu+Lzu4eHaDgPB9hjU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  # NEON does not work on aarch64, we disable it
  cmakeFlags = lib.optionals stdenv.isAarch64 ["-DCMAKE_CXX_FLAGS=-DLIBYUV_DISABLE_NEON"];

  buildInputs = [ libjpeg ];

  meta = with lib; {
    homepage = "https://chromium.googlesource.com/libyuv/libyuv";
    description = "Open source project that includes YUV scaling and conversion functionality";
    platforms = platforms.linux;
    maintainers = with maintainers; [ leixb ];
    license = licenses.bsd3;
  };
}
