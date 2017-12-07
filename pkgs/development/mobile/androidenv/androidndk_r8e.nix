{ stdenv, fetchurl, zlib, ncurses, lib, makeWrapper
, coreutils, file, findutils, gawk, gnugrep, gnused, jdk, which
, platformTools
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "android-ndk-r8e";

  src = if stdenv.system == "i686-linux"
    then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86.tar.bz2";
      sha256 = "c2c4e0c8b3037149a0f5dbb08d72f814a52af4da9fff9d80328c675457e95a98";
    }
    else if stdenv.system == "x86_64-linux" then fetchurl {
      url = "http://dl.google.com/android/ndk/${name}-linux-x86_64.tar.bz2";
      sha256 = "093gf55zbh38p2gk5bdykj1vg9p5l774wjdzw5mhk4144jm1wdq7";
    }
    else throw "platform ${stdenv.system} not supported!";

  phases = "buildPhase";

  buildInputs = [ makeWrapper ];

  buildCommand = let
    bin_path = "$out/bin";
    pkg_path = "$out/libexec/${name}";
    sed_script_1 =
      "'s|^PROGDIR=`dirname $0`" +
      "|PROGDIR=`dirname $(readlink -f $(which $0))`|'";
    sed_script_2 =
      "'s|^MYNDKDIR=`dirname $0`" +
      "|MYNDKDIR=`dirname $(readlink -f $(which $0))`|'";
    runtime_paths = (lib.makeBinPath [
      coreutils file findutils
      gawk gnugrep gnused
      jdk
      which
    ]) + ":${platformTools}/platform-tools";
  in ''
    set -x
    mkdir -pv $out/libexec
    cd $out/libexec
    tar -xjf $src

    # so that it doesn't fail because of read-only permissions set
    cd -
    patch -p1 \
        --no-backup-if-mismatch \
        -d $out/libexec/${name} < ${ ./make-standalone-toolchain_r8e.patch }
    cd ${pkg_path}

    find $out \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm -0100 \) \
        \) -exec patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-*so.? \
                          --set-rpath ${stdenv.lib.makeLibraryPath [ zlib ncurses ]} {} \;
    # fix ineffective PROGDIR / MYNDKDIR determination
    for i in ndk-build ndk-gdb ndk-gdb-py
    do
        sed -i -e ${sed_script_1} $i
    done
    sed -i -e ${sed_script_2} ndk-which
    # a bash script
    patchShebangs ndk-which
    # wrap
    for i in ndk-build ndk-gdb ndk-gdb-py ndk-which
    do
        wrapProgram "$(pwd)/$i" --prefix PATH : "${runtime_paths}"
    done
    # make some executables available in PATH
    mkdir -pv ${bin_path}
    for i in \
        ndk-build ndk-depends ndk-gdb ndk-gdb-py ndk-gdb.py ndk-stack ndk-which
    do
        ln -sf ${pkg_path}/$i ${bin_path}/$i
    done
  '';
}
