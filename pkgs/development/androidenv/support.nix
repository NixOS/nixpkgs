{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-support-r11";
  src = fetchurl {
    url = https://dl-ssl.google.com/android/repository/support_r11.zip;
    sha1 = "d30d182d8e4c86bb4464c03a83ccffce7bc84ecd";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}