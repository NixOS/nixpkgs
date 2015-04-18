{ stdenv, cmake, callPackage }:
let
  source = callPackage ./source.nix { };
in
stdenv.mkDerivation rec {
  name = "gtest-${source.version}";

  src = source;

  buildInputs = [ cmake ];

  configurePhase = ''
    mkdir build
    cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v libgtest.a libgtest_main.a $out/lib
    cp -v -r ../include $out
    cp -v -r ../src $out
  '';

  meta = with stdenv.lib; {
    description = "Google's framework for writing C++ tests";
    homepage = https://code.google.com/p/googletest/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ zoomulator ];
  };

  passthru = { inherit source; };
}
