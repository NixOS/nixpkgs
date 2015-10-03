{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "22.1.1";
  name = "android-support-r${version}";
  src = fetchurl {
    url = "https://dl-ssl.google.com/android/repository/support_r${version}.zip";
    sha1 = "jifv8yjg5jrycf8zd0lfsra00yscggc8";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}
