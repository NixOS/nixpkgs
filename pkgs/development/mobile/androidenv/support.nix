{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-support-r20";
  src = fetchurl {
    url = https://dl-ssl.google.com/android/repository/support_r20.zip;
    sha1 = "719c260dc3eb950712988f987daaf91afa9e36af";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}
