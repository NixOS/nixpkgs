{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "23.0.1";
  name = "android-support-r${version}";
  src = fetchurl {
    url = "https://dl.google.com/android/repository/support_r${version}.zip";
    sha1 = "fbe529716943053d0ce0d7f058d79f1a848cdff9";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}
