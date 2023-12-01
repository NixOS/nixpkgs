{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config, gtest
, withZlibCompat ? false
}:

stdenv.mkDerivation rec {
  pname = "zlib-ng";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    rev = version;
    hash = "sha256-EIAeRpmPFodbqQfMOFuGq7cZOnfR9xg8KN+5xa7e9J8=";
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
