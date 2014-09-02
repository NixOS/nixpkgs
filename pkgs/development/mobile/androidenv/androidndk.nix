{ stdenv, fetchurl, lib, zlib, ncurses, makeWrapper
, coreutils, file, findutils, gawk, gnugrep, gnused, jdk, which
# XXX: some of the following might be necessary too
#, binutils, curl, gcc-wrapper, gnumake, gnutar, openssh, pbzip2, perl, procps
#, unzip, wget, zip
, platformTools
}:

let
  the_version = "r10";

in

stdenv.mkDerivation rec {
  name = "android-ndk-${the_version}";

  src =
    if stdenv.system == "i686-linux" then fetchurl {
      url = "https://dl.google.com/android/ndk/" +
            "android-ndk32-${the_version}-linux-x86.tar.bz2";
      sha256 =
        "7480eea8fe699cfc6a3fcfca9debe8d7e2cd6ef00e31e12b91dead49fcb782b4";
    } else if stdenv.system == "x86_64-linux" then fetchurl {
      url = "https://dl.google.com/android/ndk/" +
            "android-ndk64-${the_version}-linux-x86_64.tar.bz2";
      sha256 =
        "b99bbc74973d0b2c17df22bc0ba9e61704d6f631deb036885fce05964d9ec921";
    } else throw "platform not ${stdenv.system} supported!";

  phases = "buildPhase";

  buildInputs = [ which makeWrapper ];

  buildCommand = let
    bin_path = "$out/bin";
    pkg_path = "$out/libexec/${name}";
    sed_script_1 =
      "'s|^PROGDIR=`dirname $0`" +
      "|PROGDIR=`dirname $(readlink -f $(which $0))`|'";
    sed_script_2 =
      "'s|^MYNDKDIR=`dirname $0`" +
      "|MYNDKDIR=`dirname $(readlink -f $(which $0))`|'";
    runtime_paths = (lib.makeSearchPath "bin" [
      coreutils file findutils
      gawk gnugrep gnused
      jdk
      which
    ]) + ":${platformTools}/platform-tools";
  in ''
    set -x
    mkdir -pv $out/libexec
    cd $out/libexec
    tar xf $src
    cd ${pkg_path}
    # time to massage...
    # XXX: androidsdk.nix may have hints for appropriate patchelf-ing
    find \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm /0100 \) \
        \) -exec patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-*so.? \
                          --set-rpath ${zlib}/lib:${ncurses}/lib {} \;
    # fix ineffective PROGDIR / MYNDKDIR determination
    for i in ndk-build ndk-gdb ndk-gdb-py
    do
        sed -i -e ${sed_script_1} $i
    done
    sed -i -e ${sed_script_2} ndk-which
    # a bash script
    patchShebangs ndk-which
    # make some executables available in PATH
    mkdir -pv ${bin_path}
    for i in \
        ndk-build ndk-depends ndk-gdb ndk-gdb-py ndk-gdb.py ndk-stack ndk-which
    do
        ln -sf ${pkg_path}/$i ${bin_path}/$i
    done
    # wrap
    for i in ndk-build ndk-gdb ndk-gdb-py ndk-which
    do
        wrapProgram "${bin_path}/$i" --prefix PATH : "${runtime_paths}"
    done
  '';
}
