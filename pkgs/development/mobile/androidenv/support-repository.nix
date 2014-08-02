{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-support-repository-r5";
  src = fetchurl {
    url = http://dl-ssl.google.com/android/repository/android_m2repository_r05.zip;
    sha1 = "2ee9723da079ba0d4fe2a185e00ded842de96f13";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
