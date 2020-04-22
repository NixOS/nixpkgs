{ stdenvNoCC, fetchurl, qemu, expect, writeScript, ncurses }:

let

  # We execute the installer in qemu-user, because otherwise the
  # installer fails to open itself due to a failed stat() call. This
  # seems like an incompatibility of new Linux kernels to run this
  # ancient binary.
  performInstall = writeScript "perform-ow-install" ''
    #!${expect}/bin/expect -f

    spawn env TERMINFO=${ncurses}/share/terminfo TERM=vt100 ${qemu}/bin/qemu-i386 [lindex $argv 0]

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
  pname = "open-watcom-bin";
  version = "1.9";

  src = fetchurl {
    url = "http://ftp.openwatcom.org/install/open-watcom-c-linux-${version}";
    sha256 = "1wzkvc6ija0cjj5mcyjng5b7hnnc5axidz030c0jh05pgvi4nj7p";
  };

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    cp ${src} install-bin
    chmod +x install-bin

    ${performInstall} install-bin
  '';

  meta = with stdenvNoCC.lib; {
    description = "A C/C++ Compiler (binary distribution)";
    homepage = "http://www.openwatcom.org/";
    license = licenses.watcom;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.blitz ];
  };
}
