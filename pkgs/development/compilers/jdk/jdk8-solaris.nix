{ stdenv
, fetchurl
, unzip
}:

let

  update = "72";

  build = "02";

  # Find new versions at: https://jdk8.java.net/download.html
  x64 = fetchurl {
    url  = http://www.java.net/download/jdk8u72/archive/b02/binaries/jdk-8u72-ea-bin-b02-solaris-x64-13_oct_2015.tar.gz;
    md5  = "8d47d5e758e20facc552b1d88361650d";
  };

in

stdenv.mkDerivation {
  name = "jdk-8u${update}b${build}";

  src = x64;

  buildInputs = [unzip];

  installPhase = ''
    # Remove junk
    rm -f  *.zip
    mkdir -p $out
    cp -av * $out
  '';

  dontStrip = true;

  meta.license = "unfree";
  meta.platforms = stdenv.lib.platforms.illumos;
}
