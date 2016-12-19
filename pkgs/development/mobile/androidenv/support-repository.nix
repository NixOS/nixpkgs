{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "40";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "http://dl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha1 = "782e7233f18c890463e8602571d304e680ce354c";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
