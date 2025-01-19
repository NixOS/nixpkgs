{
  lib,
  stdenvNoCC,
  fetchurl,
  qemu,
  writeScript,
  writeScriptBin,
  ncurses,
  bash,
  coreutils,
  unixtools,
}:

let

  # We execute all OpenWatcom binaries in qemu-user, because otherwise
  # some binaries (most notably the installer itself and wlib) fail to
  # use the stat() systemcall. The failure mode is that it returns
  # EOVERFLOW for completely legitimate requests. This seems like an
  # incompatibility of new Linux kernels to run this ancient binary.
  wrapLegacyBinary = writeScript "wrapLegacyBinary" ''
    #!${bash}/bin/bash

    set -eu

    if [ $# -ne 2 ]; then
       echo "Usage: $0 unwrapped-binary wrapped-binary"
       exit 1
    fi

    IN="$(${coreutils}/bin/realpath $1)"
    OUT="$2"
    ARGV0="$(basename $2)"

    cat > "$OUT" <<EOF
    #!${bash}/bin/bash

    TERMINFO=${ncurses}/share/terminfo TERM=vt100 exec ${qemu}/bin/qemu-i386 -0 $ARGV0 $IN "\$@"
    EOF

    chmod +x "$OUT"
  '';

  wrapInPlace = writeScriptBin "wrapInPlace" ''
    #!${bash}/bin/bash

    set -eu

    if [ $# -ne 1 ]; then
       echo "Usage: $0 unwrapped-binary"
       exit 1
    fi

    TARGET="$1"

    mv "$TARGET" "$TARGET-unwrapped"
    chmod +x "$TARGET-unwrapped"

    exec ${wrapLegacyBinary} "$TARGET-unwrapped" "$TARGET"
  '';

in
stdenvNoCC.mkDerivation rec {
  pname = "${passthru.prettyName}-unwrapped";
  version = "1.9";

  src = fetchurl {
    url = "http://ftp.openwatcom.org/install/open-watcom-c-linux-${version}";
    sha256 = "1wzkvc6ija0cjj5mcyjng5b7hnnc5axidz030c0jh05pgvi4nj7p";
  };

  nativeBuildInputs = [
    wrapInPlace
    unixtools.script
  ];

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cp ${src} install-bin-unwrapped
    wrapInPlace install-bin-unwrapped
  '';

  installPhase = ''
    # Command line options to do an unattended install are documented in
    # https://github.com/open-watcom/open-watcom-v2/blob/master/bld/setupgui/setup.txt
    script -c "./install-bin-unwrapped -dDstDir=$out -dFullInstall=1 -i"

    for e in $(find $out/binl -type f -executable); do
      echo "Wrapping $e"
      wrapInPlace "$e"
    done
  '';

  passthru.prettyName = "open-watcom-bin";

  meta = with lib; {
    description = "Project to maintain and enhance the Watcom C, C++, and Fortran cross compilers and tools";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "http://www.openwatcom.org/";
    license = licenses.watcom;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ maintainers.blitz ];
  };
}
