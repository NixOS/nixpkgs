{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "23.2.1";
  name = "android-support-r${version}";
  src = fetchurl {
    url = "https://dl.google.com/android/repository/support_r${version}.zip";
    sha1 = "azl7hgps1k98kmbhw45wwbrc86y1n4j1";
  };
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';
  
  buildInputs = [ unzip ];
}
