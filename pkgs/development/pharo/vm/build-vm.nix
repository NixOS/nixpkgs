{ stdenv, fetchurl, cmake, bash, unzip, glibc, openssl, gcc, mesa, freetype, xorg, alsaLib, cairo }:

{ name, src, binary-basename, ... }:

stdenv.mkDerivation rec {

  inherit name src binary-basename;

  sources10Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV10.sources.zip;
    sha256 = "0aijhr3w5w3jzmnpl61g6xkwyi2l1mxy0qbvr9k3whz8zlrsijh2";
  };

  sources20Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV20.sources.zip;
    sha256 = "1xsc0p361pp8iha5zckppw29sbapd706wbvzvgjnkv2n6n1q5gj7";
  };

  sources30Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV30.sources.zip;
    sha256 = "08d9a7gggwpwgrfbp7iv5896jgqz3vgjfrq19y3jw8k10pva98ak";
  };

  sources40Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV40.sources.zip;
    sha256 = "1xq1721ql19hpgr8ir372h92q7g8zwd6k921b21dap4wf8djqnpd";
  };

  # Building
  preConfigure = ''
    cd build/
  '';
  resources = ./resources;
  installPhase = ''
    echo Current directory $(pwd)
    echo Creating prefix "$prefix"
    mkdir -p "$prefix/lib/pharo-vm"

    cd ../../results

    mv vm-display-null vm-display-null.so
    mv vm-display-X11 vm-display-X11.so
    mv vm-sound-null vm-sound-null.so
    mv vm-sound-ALSA vm-sound-ALSA.so
    mv pharo pharo-vm

    cp * "$prefix/lib/pharo-vm"

    cp -R "$resources/"* "$prefix/"

    mkdir $prefix/bin

    chmod u+w $prefix/bin
    cat > $prefix/bin/${binary-basename}-x <<EOF
    #!${bash}/bin/bash

    # disable parameter expansion to forward all arguments unprocessed to the VM
    set -f

    exec $prefix/lib/pharo-vm/pharo-vm "\$@"
    EOF

    cat > $prefix/bin/${binary-basename}-nox <<EOF
    #!${bash}/bin/bash

    # disable parameter expansion to forward all arguments unprocessed to the VM
    set -f

    exec $prefix/lib/pharo-vm/pharo-vm -vm-display-null "\$@"
    EOF

    chmod +x $prefix/bin/${binary-basename}-x $prefix/bin/${binary-basename}-nox

    unzip ${sources10Zip} -d $prefix/lib/pharo-vm/
    unzip ${sources20Zip} -d $prefix/lib/pharo-vm/
    unzip ${sources30Zip} -d $prefix/lib/pharo-vm/
    unzip ${sources40Zip} -d $prefix/lib/pharo-vm/
  '';

  buildInputs = [ bash unzip cmake glibc openssl gcc mesa freetype xorg.libX11 xorg.libICE xorg.libSM alsaLib cairo ];

  meta = {
    description = "Clean and innovative Smalltalk-inspired environment";
    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.

      This package provides the executable VM. You should probably not care
      about this package (which represents a packaging detail) and have a
      look at the pharo-vm-core package instead.

      Please fill bug reports on http://bugs.pharo.org under the 'Ubuntu
      packaging (ppa:pharo/stable)' project.
    '';
    homepage = http://pharo.org;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.DamienCassou ];
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
