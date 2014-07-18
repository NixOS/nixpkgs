{ stdenv, fetchurl, lib, zlib, ncurses, makeWrapper
, coreutils, file, findutils, gawk, gnugrep, gnused, jdk, which
# XXX: some of the following might be necessary too
#, binutils, curl, gcc-wrapper, gnumake, gnutar, openssh, pbzip2, perl, procps
#, unzip, wget, zip
, platformTools
}:

let

  version = "r10";
  _name = "android-ndk-${version}";
  #
  _binPath = "$out/bin";
  _pkgPath = "$out/libexec/${_name}";
  #
  _sedScript1 =
    "'s|^PROGDIR=`dirname $0`|PROGDIR=`dirname $(readlink -f $(which $0))`|'";
  _sedScript2 =
    "'s|^MYNDKDIR=`dirname $0`|MYNDKDIR=`dirname $(readlink -f $(which $0))`|'";
  #
  _runtimeDeps = [
    coreutils
    file
    findutils
    gawk
    gnugrep
    gnused
    jdk
    which
    platformTools
  ];
  _runtimePaths = (lib.concatStringsSep "/bin:" _runtimeDeps) + "/platform-tools";

in

stdenv.mkDerivation rec {
  name = "${_name}";

  src =
    if stdenv.system == "i686-linux" then fetchurl {
      url = "https://dl.google.com/android/ndk/" +
            "android-ndk32-${version}-linux-x86.tar.bz2";
      sha256 =
        "7480eea8fe699cfc6a3fcfca9debe8d7e2cd6ef00e31e12b91dead49fcb782b4";
    } else if stdenv.system == "x86_64-linux" then fetchurl {
      url = "https://dl.google.com/android/ndk/" +
            "android-ndk64-${version}-linux-x86_64.tar.bz2";
      sha256 =
        "b99bbc74973d0b2c17df22bc0ba9e61704d6f631deb036885fce05964d9ec921";
    } else throw "platform not ${stdenv.system} supported!";

  phases = "buildPhase";

  buildInputs = [ which makeWrapper ];

  buildCommand = ''
    set -x
    ensureDir $out/libexec
    cd $out/libexec
    tar xf $src
    cd ${_pkgPath}
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
        sed -i -e ${_sedScript1} $i
    done
    sed -i -e ${_sedScript2} ndk-which
    # a bash script
    patchShebangs ndk-which
    # make some executables available in PATH
    ensureDir ${_binPath}
    for i in \
        ndk-build ndk-depends ndk-gdb ndk-gdb-py ndk-gdb.py ndk-stack ndk-which
    do
        ln -sf ${_pkgPath}/$i ${_binPath}/$i
    done
    # wrap
    for i in ndk-build ndk-gdb ndk-gdb-py ndk-which
    do
        wrapProgram "${_binPath}/$i" --prefix PATH : "${_runtimePaths}"
    done
  '';
}
