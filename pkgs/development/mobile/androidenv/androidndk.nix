{ stdenv, fetchurl, zlib, ncurses, p7zip, lib, makeWrapper
, coreutils, file, findutils, gawk, gnugrep, gnused, jdk, which
, platformTools , pinToVersion8 ? false
}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = if pinToVersion8 then
      "android-ndk-r8e"
    else
      "android-ndk-r10c";

  src = if stdenv.system == "i686-linux"
    then fetchurl {
      url = if pinToVersion8 then "http://dl.google.com/android/ndk/${name}-linux-x86.tar.bz2"
            else "http://dl.google.com/android/ndk/${name}-linux-x86.bin";
      sha256 = if pinToVersion8 then "c2c4e0c8b3037149a0f5dbb08d72f814a52af4da9fff9d80328c675457e95a98"
               else "0gyq68zrpzj3gkh81czs6r0jmikg5rwzh1bqg4rk16g2nxm4lll3";
    }
    else if stdenv.system == "x86_64-linux" then fetchurl {
      url = if pinToVersion8 then "http://dl.google.com/android/ndk/${name}-linux-x86_64.tar.bz2"
            else "http://dl.google.com/android/ndk/${name}-linux-x86_64.bin";
      sha256 = if pinToVersion8 then "093gf55zbh38p2gk5bdykj1vg9p5l774wjdzw5mhk4144jm1wdq7"
               else "126rqzkmf8xz1hqdziwx81yln17hpivs2j45rxhzdr45iw9b758c";
    }
    else throw "platform ${stdenv.system} not supported!";

  phases = "buildPhase";

  buildInputs = if pinToVersion8 then [ makeWrapper ]
                else [ p7zip makeWrapper ];

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

    ${if pinToVersion8 then "tar -xjf $src"
      else "7z x $src"}

    # so that it doesn't fail because of read-only permissions set
    cd -
    patch -p1 \
        --no-backup-if-mismatch \
        ${if pinToVersion8 then 
             "-d $out/libexec/${name} < ${ ./make-standalone-toolchain_r8e.patch }"
        else "-d $out/libexec/${name} < ${ ./make-standalone-toolchain.patch }"}
    cd ${pkg_path}

    find $out \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm /0100 \) \
        \) -exec patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-*so.? \
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
