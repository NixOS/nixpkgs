{ stdenv, cmake, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "gtest-${version}";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-${version}";
    sha256 = "0270msj6n7mggh4xqqjp54kswbl7mkcc8px1p5dqdpmw5ngh9fzk";
  };

  buildInputs = [ cmake ];

  configurePhase = ''
    mkdir build
    cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v googlemock/gtest/libgtest.a googlemock/gtest/libgtest_main.a googlemock/libgmock.a googlemock/libgmock_main.a $out/lib
    ln -s $out/lib/libgmock.a $out/lib/libgoogletest.a
    mkdir -p $out/include
    cp -v -r ../googlemock/include/gmock $out/include
    cp -v -r ../googletest/include/gtest $out/include
    mkdir -p $out/src
    cp -v -r ../googlemock/src/* ../googletest/src/* $out/src
  '';

  meta = with stdenv.lib; {
    description = "Google's framework for writing C++ tests";
    homepage = https://github.com/google/googletest;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ zoomulator ivan-tkatchev ];
  };
}
