{ stdenv, fetchurl, zlib, ncurses, p7zip
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "android-ndk-r10c";

  src = if stdenv.system == "i686-linux"
    then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86.bin";
      sha256 = "0gyq68zrpzj3gkh81czs6r0jmikg5rwzh1bqg4rk16g2nxm4lll3";
    }
    else if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86_64.bin";
      sha256 = "126rqzkmf8xz1hqdziwx81yln17hpivs2j45rxhzdr45iw9b758c";
    }
    else throw "platform ${stdenv.system} not supported!";

  phases = "installPhase";

  buildInputs = [ p7zip ];

  installPhase = ''
    set -x
    mkdir -pv $out
    7z x $src
    mv */* $out

    # so that it doesn't fail because of read-only permissions set
    patch -p1 -d $out < ${ ./make-standalone-toolchain.patch }

    find $out \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm +0100 \) \
        \) -exec patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-*so.? \
        --set-rpath ${zlib}/lib:${ncurses}/lib {} \;
  '';
}
