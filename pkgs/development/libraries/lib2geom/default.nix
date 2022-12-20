{ stdenv
, fetchpatch
, fetchFromGitLab
, cmake
, ninja
, pkg-config
, boost
, glib
, gsl
, cairo
, double-conversion
, gtest
, lib
}:

stdenv.mkDerivation rec {
  pname = "lib2geom";
  version = "1.2.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    owner = "inkscape";
    repo = "lib2geom";
    rev = "refs/tags/${version}";
    sha256 = "sha256-xkUxcAk8KJkL482R7pvgmCT+5I8aUMm/q25pvK3ZPuY=";
  };

  patches = [
    # Fixed upstream, remove when the new version releases:
    # https://gitlab.com/inkscape/lib2geom/-/issues/49
    (fetchpatch {
      name = "expect-double-eq-in-choose-test.patch";
      url = "https://gitlab.com/inkscape/lib2geom/-/commit/5b7c75dd3841cb415f163f0a81f556c57d3e0a83.patch";
      sha256 = "RMgwJkylrGFTTrqBzqs5j2LMSLsHhcE/UT1pKBZnU50=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    glib
    gsl
    cairo
    double-conversion
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    "-D2GEOM_BUILD_SHARED=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Easy to use 2D geometry library in C++";
    homepage = "https://gitlab.com/inkscape/lib2geom";
    license = [ licenses.lgpl21Only licenses.mpl11 ];
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
