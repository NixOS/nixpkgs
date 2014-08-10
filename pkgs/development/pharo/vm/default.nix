{ stdenv, fetchurl, cmake, bash, unzip, glibc, openssl, gcc, mesa, freetype, xlibs, alsaLib }:

stdenv.mkDerivation rec {
  name = "pharo-vm-core-i386-2014.06.25";
  system = "x86_32-linux";
  src = fetchurl {
    url = http://files.pharo.org/vm/src/vm-unix-sources/pharo-vm-2014.06.25.tar.bz2;
    md5 = "4d80d8169c2f2f0355c43ee90bbad23f";
  };

  sources10Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV10.sources.zip;
    md5 = "3476222a0345a6f8f8b6093b5e3b30fb";
  };

  sources20Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV20.sources.zip;
    md5 = "a145b0733f9d68d9ce6a76270b6b9ec8";
  };

  sources30Zip = fetchurl {
    url = http://files.pharo.org/sources/PharoV30.sources.zip;
    md5 = "bb0a66b8968ef7d0da97ec86331f68c8";
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
    cat > $prefix/bin/pharo-vm-x <<EOF
    #!${bash}/bin/bash

    # disable parameter expansion to forward all arguments unprocessed to the VM
    set -f

    exec $prefix/lib/pharo-vm/pharo-vm "\$@"
    EOF

    cat > $prefix/bin/pharo-vm-nox <<EOF
    #!${bash}/bin/bash

    # disable parameter expansion to forward all arguments unprocessed to the VM
    set -f

    exec $prefix/lib/pharo-vm/pharo-vm -vm-display-null "\$@"
    EOF

    chmod +x $prefix/bin/pharo-vm-x $prefix/bin/pharo-vm-nox

    unzip ${sources10Zip} -d $prefix/lib/pharo-vm/
    unzip ${sources20Zip} -d $prefix/lib/pharo-vm/
    unzip ${sources30Zip} -d $prefix/lib/pharo-vm/
  '';

  patches = [ patches/pharo-is-not-squeak.patch patches/fix-executable-name.patch patches/fix-cmake-root-directory.patch ];
 
  buildInputs = [ bash unzip cmake glibc openssl gcc mesa freetype xlibs.libX11 xlibs.libICE xlibs.libSM alsaLib ];

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