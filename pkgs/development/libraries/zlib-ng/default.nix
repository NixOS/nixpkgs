{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config
, withZlibCompat ? false
}:

stdenv.mkDerivation rec {
  pname = "zlib-ng";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    rev = version;
    sha256 = "1cl6asrav2512j7p02zcpibywjljws0m7aazvb3q2r9qiyvyswji";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=/"
    "-DBUILD_SHARED_LIBS=ON"
    "-DINSTALL_UTILS=ON"
  ] ++ lib.optionals withZlibCompat [ "-DZLIB_COMPAT=ON" ];

  meta = with lib; {
    description = "zlib data compression library for the next generation systems";
    homepage    = "https://github.com/zlib-ng/zlib-ng";
    license     = licenses.zlib;
    platforms   = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
