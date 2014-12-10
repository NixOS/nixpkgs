{ stdenv
, fetchurl
, unzip
}:

let

  update = "40";

  build = "17";

  # Find new versions at: https://jdk8.java.net/download.html
  x64 = fetchurl {
    url  = http://www.java.net/download/jdk8u40/archive/b17/binaries/jdk-8u40-ea-bin-b17-solaris-x64-02_dec_2014.tar.gz;
    md5  = "ee360796cf6562e5d65d5750044d9420";
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
