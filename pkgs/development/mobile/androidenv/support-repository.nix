{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  version = "16";
  name = "android-support-repository-r${version}";
  src = fetchurl {
    url = "https://dl-ssl.google.com/android/repository/android_m2repository_r${version}.zip";
    sha256 = "12sa66amisk4g9wlvwlmgrrkrv3iy70kpridhk4gjci7gsksalks";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
