{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "35";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "http://dl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha1 = "2wi1b38n3dmnikpwbwcbyy2xfws1683s";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
