{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, gtest
, withZlibCompat ? false
}:

stdenv.mkDerivation rec {
  pname = "zlib-ng";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    rev = version;
    hash = "sha256-okNmobCVAC9y7tjZqFd0DBhOjs3WWRPK8jvK1j9G29k=";
  };

  outputs = [ "out" "dev" "bin" ];

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ gtest ];

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
