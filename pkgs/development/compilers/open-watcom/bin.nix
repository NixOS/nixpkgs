{ lib, stdenvNoCC, fetchurl, qemu, expect, writeScript, writeScriptBin, ncurses, bash, coreutils }:

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

  # Do a scripted installation of OpenWatcom with its original installer.
  #
  # If maintaining this expect script turns out to be too much of a
  # hassle, we can switch to just using `unzip' on the installer and
  # the correct file permissions manually.
  performInstall = writeScriptBin "performInstall" ''
    #!${expect}/bin/expect -f

    spawn [lindex $argv 0]

    # Wait for button saying "I agree" with escape sequences.
    expect "gree"

    # Navigate to "I Agree!" and hit enter.
    send "\t\t\n"

    expect "Install Open Watcom"

    # Where do we want to install to.
    send "$env(out)\n"

    expect "will be installed"

    # Select Full Installation, Next
    send "fn"

    expect "Setup will now copy"

    # Next
    send "n"

    expect "completed successfully"
    send "\n"
  '';

in
stdenvNoCC.mkDerivation rec {
  pname = "${passthru.prettyName}-unwrapped";
  version = "1.9";

  src = fetchurl {
    url = "http://ftp.openwatcom.org/install/open-watcom-c-linux-${version}";
    sha256 = "1wzkvc6ija0cjj5mcyjng5b7hnnc5axidz030c0jh05pgvi4nj7p";
  };

  nativeBuildInputs = [ wrapInPlace performInstall ];

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cp ${src} install-bin-unwrapped
    wrapInPlace install-bin-unwrapped
  '';

  installPhase = ''
    performInstall ./install-bin-unwrapped

    for e in $(find $out/binl -type f -executable); do
      echo "Wrapping $e"
      wrapInPlace "$e"
    done
  '';

  passthru.prettyName = "open-watcom-bin";

  meta = with lib; {
    description = "A project to maintain and enhance the Watcom C, C++, and Fortran cross compilers and tools";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "http://www.openwatcom.org/";
    license = licenses.watcom;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.blitz ];
  };
}
