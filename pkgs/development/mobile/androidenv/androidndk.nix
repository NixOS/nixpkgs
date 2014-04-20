{ stdenv, fetchurl, zlib, ncurses
}:

stdenv.mkDerivation rec {
  name = "android-ndk-r9d";

  src = if stdenv.system == "i686-linux"
    then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86.tar.bz2";
      md5 = "6c1d7d99f55f0c17ecbcf81ba0eb201f";
    }
    else if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86_64.tar.bz2";
      md5 = "c7c775ab3342965408d20fd18e71aa45";
    }
    else throw "platform not ${stdenv.system} supported!";

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out
    tar xf $src
    mv */* $out
    find $out \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm +0100 \) \
        \) -exec patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-*so.? \
        --set-rpath ${zlib}/lib:${ncurses}/lib {} \;
  '';
}
