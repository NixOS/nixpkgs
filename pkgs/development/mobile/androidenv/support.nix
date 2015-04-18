{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-support-r21";
  src = fetchurl {
    url = https://dl-ssl.google.com/android/repository/support_r21.zip;
    sha1 = "f9ef8def5c64f17cd8bc41c5efddd37cb155f0be";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}
