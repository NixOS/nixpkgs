{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "23.1";
  name = "android-support-r${version}";
  src = fetchurl {
    url = "https://dl.google.com/android/repository/support_r${version}.zip";
    sha1 = "c43a56fcd1c2aa620f6178a0ef529623ed77b3c7";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}
