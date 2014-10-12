{ stdenv, fetchurl, zlib, ncurses
}:

stdenv.mkDerivation rec {
  name = "android-ndk-r9d";

  src = if stdenv.system == "i686-linux"
    then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86.tar.bz2";
      sha256 = "0lrxx8rclmda72dynh0qjr6xpcnv5vs3gc96jcia37h8mmn2xv6m";
    }
    else if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86_64.tar.bz2";
      sha256 = "16miwrnf3c7x7rlpmssmjx9kybmapsjyamjyivhabb2wm21x3q8l";
    }
    else throw "platform not ${stdenv.system} supported!";

  phases = "installPhase";

  installPhase = ''
    set -x
    mkdir -pv $out
    tar xf $src
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
