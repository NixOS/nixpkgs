{ stdenv, fetchurl, bash, unzip, glibc, openssl, gcc, mesa, freetype, xorg, alsaLib, cairo, libuuid, makeDesktopItem, autoreconfHook, gcc6, fetchFromGitHub }:

{ name, src, binary-basename, version, sourceDate, sourceURL, ... }:

# Build the Pharo VM
stdenv.mkDerivation rec {

  inherit name src binary-basename;
  pharo-share = import ./share.nix { inherit stdenv fetchurl unzip; };
  # Note: -fPIC causes the VM to segfault.
  hardeningDisable = [ "format" "pic" ];

  # Translate the target architecture name into the VM format
  flavor =
    if      stdenv.isLinux && stdenv.isi686    then "linux32x86"
    else if stdenv.isLinux && stdenv.isx86_64  then "linux64x64"
    else if stdenv.isDarwin && stdenv.isi686   then "macos32x86"
    else if stdenv.isDarwin && stdenv.isx86_64 then "macos64x64"
    else abort "Unsupported platform: only Linux/Darwin x86/x64 are supported.";

  # VM has separate source trees for 32-bit vs 64-bit variants
  vm = if stdenv.is64bit then "spur64src" else "spursrc";

  # Regenerate the configure script.
  # This may not be necessary but skipped this step seems to cause breakage.
  autoreconfPhase = ''
    (cd opensmalltalk-vm/platforms/unix/config && make)
  '';

  # Configure with options modeled on the 'mvm' build script in the source tree
  configureScript = "platforms/unix/config/configure";
  configureFlags = [ "--without-npsqueak"
                     "--with-vmversion=5.0"
                     "--with-src=${vm}" ];
  CFLAGS = "-msse2 -D_GNU_SOURCE -DCOGMTVM=0 -g -O2 -DNDEBUG -DDEBUGVM=0";
  LDFLAGS = "-Wl,-z,now";

  # Patch the source before building.
  prePatch = ''
    patchShebangs opensmalltalk-vm/build.${flavor}
    # Fix hard-coded path to /bin/rm in a script
    sed -i -e 's:/bin/rm:rm:' opensmalltalk-vm/platforms/unix/config/mkmf
    # Fill in mandatory metadata about the VM source version
    sed -i -e 's!\$Date\$!$Date: ${sourceDate} $!' \
           -e 's!\$Rev\$!$Rev: ${version} $!' \
           -e 's!\$URL\$!$URL: ${sourceURL} $!' \
           opensmalltalk-vm/platforms/Cross/vm/sqSCCSVersion.h
  '';

  preConfigure = ''
    cd opensmalltalk-vm
    cp build.${flavor}/pharo.cog.spur/plugins.{ext,int} .
  '';

  # (No special build phase.)

  installPhase = ''
    # Install in working directory and then copy
    make install-squeak install-plugins prefix=$(pwd)/products

    # Copy binaries & rename from 'squeak' to 'pharo'
    mkdir -p $out/lib
    cp    products/lib/squeak/5.0-*/squeak $out/lib/pharo

    cp -r products/lib/squeak/5.0-*/*.so $out/lib/
    ln -s "${pharo-share}/lib/"*.sources $out/lib/

    # Create shell script wrappers pharo-vm-x and pharo-vm-nox.
    # 
    # These wrappers put all relevant libraries into the
    # LD_LIBRARY_PATH which is important because various C code in the VM
    # and Smalltalk code in the image will search for them there.
    mkdir -p $out/bin
    chmod u+w $out/bin

    # Include the ELF rpath in LD_LIBRARY_PATH too.
    # This is necessary for the Smalltalk FFI to be able to call libc.
    libs=$out/lib:$(patchelf --print-rpath $out/lib/pharo):${cairo}/lib:${mesa}/lib:${freetype}/lib:${openssl}/lib:${libuuid}/lib:${alsaLib}/lib:${xorg.libICE}/lib:${xorg.libSM}/lib

    # Graphical VM
    cat > $out/bin/${binary-basename}-x <<EOF
    #!/bin/sh
    set -f
    LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:$libs" exec $out/lib/pharo -vm-display-X11 "\$@"
    EOF
    chmod +x $prefix/bin/${binary-basename}-x

    # Headless VM
    cat > $out/bin/${binary-basename}-nox <<EOF
    #!/bin/sh
    set -f
    LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:$libs" exec $out/lib/pharo -vm-display-null "\$@"
    EOF
    chmod +x $out/bin/${binary-basename}-nox

    mkdir -p "$prefix/share/applications"
    cp "${desktopItem}/share/applications/"* $prefix/share/applications
  '';

  enableParallelBuilding = true;

  # Note: Force gcc6 because gcc5 crashes when compiling the VM.
  buildInputs = [ bash unzip glibc openssl gcc6 mesa freetype xorg.libX11 xorg.libICE xorg.libSM alsaLib cairo pharo-share libuuid autoreconfHook ];

  resources = ./resources;

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
    maintainers = [ ];
    # Pharo VM sources are packaged separately for darwin (OS X)
    platforms = with stdenv.lib;
                  intersectLists
                    platforms.mesaPlatforms
                    (subtractLists platforms.darwin platforms.unix);
  };
}
