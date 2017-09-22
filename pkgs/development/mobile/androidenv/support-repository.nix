{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "47";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "http://dl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha256 = "1l13a6myff6i8x99h1ky2j5sglwy8wc0rsbxfcbif375vh41iyd3";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
