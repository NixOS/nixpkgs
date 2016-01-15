{ stdenv, cmake, callPackage }:
let
  source = callPackage ./source.nix { };
in
stdenv.mkDerivation rec {
  name = "gmock-${source.version}";

  src = source;

  buildInputs = [ cmake ];

  buildPhase = ''
    # avoid building gtest
    make gmock gmock_main
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v libgmock.a libgmock_main.a $out/lib
    cp -v -r ../include $out
    cp -v -r ../src $out
  '';

  meta = {
    description = "Google mock: Google's framework for writing C++ mock classes";
    homepage = https://code.google.com/p/googlemock/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.auntie ];
  };

  passthru = { inherit source; };
}
