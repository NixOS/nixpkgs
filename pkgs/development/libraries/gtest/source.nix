{ fetchurl, stdenv, unzip, ... }:

stdenv.mkDerivation rec {
  name = "gtest-src-${version}";
  version = "1.7.0";

  src = fetchurl {
    url = "https://googletest.googlecode.com/files/gtest-${version}.zip";
    sha256 = "03fnw3bizw9bcx7l5qy1vz7185g33d5pxqcb6aqxwlrzv26s2z14";
  };

  buildInputs = [ unzip ];

  buildCommand = ''
    unpackPhase
    cd gtest-${version}
    mkdir $out
    cp -r * $out
  '';

  passthru = { inherit version; };
}
