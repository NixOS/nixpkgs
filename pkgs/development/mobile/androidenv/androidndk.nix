{ stdenv, fetchurl, zlib, ncurses, p7zip, lib, makeWrapper
, coreutils, file, findutils, gawk, gnugrep, gnused, jdk, which
, platformTools, python3, version, sha256
}:

stdenv.mkDerivation rec {
  name = "android-ndk-r${version}";
  inherit version;

  src = if stdenv.system == "x86_64-linux" then fetchurl {
      url = "https://dl.google.com/android/repository/${name}-linux-x86_64.zip";
      inherit sha256;
    } else throw "platform ${stdenv.system} not supported!";

  phases = "buildPhase";

  nativeBuildInputs = [ p7zip makeWrapper ];

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
      jdk python3 which
    ]) + ":${platformTools}/platform-tools";
  in ''
    set -x
    mkdir -pv $out/libexec
    cd $out/libexec
    7z x $src

    # so that it doesn't fail because of read-only permissions set
    cd -
    ${if (version == "10e") then
        ''
          patch -p1 \
            --no-backup-if-mismatch \
            -d $out/libexec/${name} < ${ ./make-standalone-toolchain_r10e.patch }
        ''
      else
        ''
          patchShebangs ${pkg_path}/build/tools/make-standalone-toolchain.sh

          patch -p1 \
            --no-backup-if-mismatch \
            -d $out/libexec/${name} < ${ ./. + builtins.toPath ("/make_standalone_toolchain.py_" + "${version}" + ".patch") }
          wrapProgram ${pkg_path}/build/tools/make_standalone_toolchain.py --prefix PATH : "${runtime_paths}"
        ''
    }
    cd ${pkg_path}

    find $out \( \
        \( -type f -a -name "*.so*" \) -o \
        \( -type f -a -perm -0100 \) \
        \) -exec patchelf --set-interpreter ${stdenv.cc.libc.out}/lib/ld-*so.? \
                          --set-rpath ${stdenv.lib.makeLibraryPath [ zlib.out ncurses ]} {} \;
    # fix ineffective PROGDIR / MYNDKDIR determination
    for i in ndk-build ${lib.optionalString (version == "10e") "ndk-gdb ndk-gdb-py"}
    do
        sed -i -e ${sed_script_1} $i
    done
    ${lib.optionalString (version == "10e") ''
      sed -i -e ${sed_script_2} ndk-which
      # a bash script
      patchShebangs ndk-which
    ''}
    # wrap
    for i in ndk-build ${lib.optionalString (version == "10e") "ndk-gdb ndk-gdb-py ndk-which"}
    do
        wrapProgram "$(pwd)/$i" --prefix PATH : "${runtime_paths}"
    done
    # make some executables available in PATH
    mkdir -pv ${bin_path}
    for i in \
        ndk-build ${lib.optionalString (version == "10e") "ndk-depends ndk-gdb ndk-gdb-py ndk-gdb.py ndk-stack ndk-which"}
    do
        ln -sf ${pkg_path}/$i ${bin_path}/$i
    done
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
