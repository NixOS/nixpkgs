{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "33";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "http://dl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha1 = "pdg5s78wypnc27fs5n62c8rrjl8gwyv4";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
