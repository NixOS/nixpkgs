{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "android-support-repository-r9";
  src = fetchurl {
    url = http://dl-ssl.google.com/android/repository/android_m2repository_r09.zip;
    sha256 = "e5295cdbc086251a2904c081038a7f10056359481c66ecff40e59177fd1c753c";
  };

  buildCommand = ''
    mkdir -p $out
    cd $out
    unzip $src
  '';

  buildInputs = [ unzip ];
}
