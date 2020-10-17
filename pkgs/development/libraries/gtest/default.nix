{ stdenv, cmake, ninja, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "gtest";
  version = "1.10.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-${version}";
    sha256 = "1zbmab9295scgg4z2vclgfgjchfjailjnvzc6f5x9jvlsdi3dpwz";
  };

  patches = [
    ./fix-cmake-config-includedir.patch
    (fetchpatch {
      name = "fix-pkgconfig-paths.patch";
      url = "https://github.com/google/googletest/commit/5126ff48d9ac54828d1947d1423a5ef2a8efee3b.patch";
      sha256 = "sha256-TBvECU/9nuvwjsCjWJP2b6DNy+FYnHIFZeuVW7g++JE=";
    })
  ];

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with stdenv.lib; {
    description = "Google's framework for writing C++ tests";
    homepage = "https://github.com/google/googletest";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ zoomulator ivan-tkatchev ];
  };
}
