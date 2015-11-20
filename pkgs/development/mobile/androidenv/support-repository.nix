{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "24";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "http://dl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha1 = "5b6d328a572172ec51dc25c3514392760e49bb81";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
