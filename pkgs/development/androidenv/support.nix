{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-support";
  src = fetchurl {
    url = https://dl-ssl.google.com/android/repository/support_r10.zip;
    sha1 = "7c62e542d46ac3bdb89e1b90503d6afae557cf7d";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}