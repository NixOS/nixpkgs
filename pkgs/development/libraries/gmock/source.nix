{ fetchzip, stdenv, unzip, ... }:

stdenv.mkDerivation rec {
  name = "gmock-src-${version}";
  version = "1.7.0";

  src = fetchzip {
    url = "https://googlemock.googlecode.com/files/gmock-${version}.zip";
    sha256="04n9p6pf3mrqsabrsncv32d3fqvd86zmcdq3gyni7liszgfk0paz";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir $out
    cp -r * $out
  '';

  passthru = { inherit version; };
}
