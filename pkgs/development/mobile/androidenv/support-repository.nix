{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "14";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "http://dl-ssl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha256 = "027mmfzvs07nbp28vn6c6cgszqdrmmgwdfzda87936lpi5dwg34p";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
