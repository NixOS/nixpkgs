{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-support-r18";
  src = fetchurl {
    url = https://dl-ssl.google.com/android/repository/support_r18.zip;
    sha1 = "bd67b4b8a6bac629f24c8aea75c3619a26d9a568";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}