{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "21";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "http://dl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha1 = "acb915c5d2c730bf98303c0cd0122bedb2954cb3";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
