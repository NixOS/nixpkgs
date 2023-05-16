<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, fetchpatch
, cmake, pkg-config, gtest
=======
{ lib, stdenv, fetchFromGitHub
, cmake, pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, withZlibCompat ? false
}:

stdenv.mkDerivation rec {
  pname = "zlib-ng";
<<<<<<< HEAD
  version = "2.1.2";
=======
  version = "2.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "zlib-ng";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-6IEH9IQsBiNwfAZAemmP0/p6CTOzxEKyekciuH6pLhw=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/zlib-ng/zlib-ng/pull/1519.patch";
      hash = "sha256-itobS8kJ2Hj3RfjslVkvEVdQ4t5eeIrsA9muRZt03pE=";
    })
  ];

  outputs = [ "out" "dev" "bin" ];

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ gtest ];

=======
    sha256 = "sha256-Q+u71XXfHafmTL8tmk4XcgpbSdBIunveL9Q78LqiZF0=";
  };

  outputs = [ "out" "dev" "bin" ];

  nativeBuildInputs = [ cmake pkg-config ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
