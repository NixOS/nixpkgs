{ stdenv, fetchurl, cmake, bash, unzip, glibc, openssl, gcc, mesa, freetype, xorg, alsaLib, cairo, makeDesktopItem }:

{ name, src, binary-basename, ... }:

stdenv.mkDerivation rec {

  inherit name src binary-basename;

  pharo-share = import ./share.nix { inherit stdenv fetchurl unzip; };

  desktopItem = makeDesktopItem {
    inherit name;
    desktopName = "Pharo VM";
    genericName = "Pharo Virtual Machine";
    exec = "${binary-basename}-x %F";
    icon = "pharo";
    terminal = "false";
    type="Application";
    startupNotify = "false";
    categories = "Development;";
    mimeType = "application/x-pharo-image";
  };

  hardeningDisable = [ "format" ];

  # Building
  preConfigure = ''
    cd build/
  '';
  resources = ./resources;
  installPhase = ''
    mkdir -p "$prefix/lib/$name"

    cd ../../results

    mv vm-display-null vm-display-null.so
    mv vm-display-X11 vm-display-X11.so
    mv vm-sound-null vm-sound-null.so
    mv vm-sound-ALSA vm-sound-ALSA.so
    mv pharo pharo-vm

    cp * "$prefix/lib/$name"

    mkdir -p "$prefix/share/applications"
    cp "${desktopItem}/share/applications/"* $prefix/share/applications

    mkdir $prefix/bin

    chmod u+w $prefix/bin
    cat > $prefix/bin/${binary-basename}-x <<EOF
    #!${bash}/bin/bash

    # disable parameter expansion to forward all arguments unprocessed to the VM
    set -f

    exec $prefix/lib/$name/pharo-vm "\$@"
    EOF

    cat > $prefix/bin/${binary-basename}-nox <<EOF
    #!${bash}/bin/bash

    # disable parameter expansion to forward all arguments unprocessed to the VM
    set -f

    exec $prefix/lib/$name/pharo-vm -vm-display-null "\$@"
    EOF

    chmod +x $prefix/bin/${binary-basename}-x $prefix/bin/${binary-basename}-nox

    ln -s "${pharo-share}/lib/"*.sources $prefix/lib/$name
  '';

  buildInputs = [ bash unzip cmake glibc openssl gcc mesa freetype xorg.libX11 xorg.libICE xorg.libSM alsaLib cairo pharo-share ];

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
    # Pharo VM sources are packaged separately for darwin (OS X)
    platforms = with stdenv.lib;
                  intersectLists
                    platforms.mesaPlatforms
                    (subtractLists platforms.darwin platforms.unix);
  };
}
