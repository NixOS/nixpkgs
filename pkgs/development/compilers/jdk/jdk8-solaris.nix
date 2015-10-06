{ stdenv
, fetchurl
, unzip
}:

let

  update = "66";

  build = "02";

  # Find new versions at: https://jdk8.java.net/download.html
  x64 = fetchurl {
    url  = http://www.java.net/download/jdk8u66/archive/b02/binaries/jdk-8u66-ea-bin-b02-solaris-x64-28_jul_2015.tar.gz;
    md5  = "823e1d184da9021bf1a4704c0b66499b";
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
