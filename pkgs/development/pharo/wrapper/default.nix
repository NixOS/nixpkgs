{ stdenv, file, makeDesktopItem, cogvm, spurvm, spur64vm ? "none" }:

stdenv.mkDerivation rec {
  name = "pharo";
  src = ./.;
  inherit cogvm spurvm spur64vm file;
  magic = ./magic;
  desktopItem = makeDesktopItem {
    inherit name;
    desktopName = "Pharo VM";
    genericName = "Pharo Virtual Machine";
    exec = "pharo %F";
    icon = "pharo";
    terminal = "false";
    type="Application";
    startupNotify = "false";
    categories = "Development;";
    mimeType = "application/x-pharo-image";
  };
  buildPhase = ''
    substituteAllInPlace ./pharo-vm.sh
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp pharo-vm.sh $out/bin/pharo-vm
    chmod +x $out/bin/pharo-vm
  '';
  meta = {
    description = "Clean and innovative Smalltalk-inspired environment";
    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.

      This package provides a wrapper script to automatically execute
      a VM that is compatible with the image being opened. This is
      helpful because different Pharo images require different VM
      builds.
    '';

    homepage = http://pharo.org;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.lukego ];
    # Pharo VM sources are packaged separately for darwin (OS X)
    platforms = with stdenv.lib;
                  intersectLists
                    platforms.mesaPlatforms
                    (subtractLists platforms.darwin platforms.unix);
  };
}

