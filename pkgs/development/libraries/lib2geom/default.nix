{ stdenv
, fetchFromGitLab
, fetchpatch
, cmake
, ninja
, pkg-config
, boost
, glib
, gsl
, cairo
, double-conversion
, gtest
}:

stdenv.mkDerivation rec {
  pname = "lib2geom-unstable";
  version = "2020-03-12";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    owner = "inkscape";
    repo = "lib2geom";
    rev = "226eb8c60f2af639d74a0229c0ba90e649e6451d";
    sha256 = "BSuqasBfig6HiKY/xtJm7CjbSaV8cW45ip59iEO5Es4=";
  };

  patches = [
    # Re-enable assertions for tests to work
    # https://gitlab.com/inkscape/lib2geom/issues/5
    # https://gitlab.com/inkscape/lib2geom/merge_requests/17
    (fetchpatch {
      url = "https://gitlab.com/inkscape/lib2geom/commit/4aa78f52232682b353eb15c219171e466987bac7.patch";
      sha256 = "XsX8SPft0RwDemJujc8lierBe4s3iw8YkW4CSlY5LsY=";
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

  cmakeBuildType = "RelWithDebugInfo"; # needed to keep assertions for tests working

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
    "-DBUILD_SHARED_LIBS=ON"
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Easy to use 2D geometry library in C++";
    homepage = "https://gitlab.com/inkscape/lib2geom";
    license = [ licenses.lgpl21 licenses.mpl11 ];
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
