{ lib, stdenv, fetchFromGitHub, fetchpatch
, cmake, pkg-config, gtest
, withZlibCompat ? false
}:

stdenv.mkDerivation rec {
  pname = "zlib-ng";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    rev = version;
    sha256 = "sha256-6IEH9IQsBiNwfAZAemmP0/p6CTOzxEKyekciuH6pLhw=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/zlib-ng/zlib-ng/pull/1519.patch";
      hash = "sha256-itobS8kJ2Hj3RfjslVkvEVdQ4t5eeIrsA9muRZt03pE=";
    })
  ];

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ cmake pkg-config gtest ];

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
