{ stdenv, file, makeDesktopItem, cog32, spur32, spur64 ? "none" }:

stdenv.mkDerivation rec {
  name = "pharo";
  src = ./.;
  inherit cog32 spur32 spur64 file;
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
    cp pharo-vm.sh $out/bin/pharo
    chmod +x $out/bin/pharo
  '';
  meta = {
    description = "Pharo virtual machine (multiple variants)";

    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.

      This package provides a front-end for starting the virtual
      machine. The command 'pharo-vm' automatically detects the type
      of image and executes a suitable virtual machine: CogV3, Spur,
      or Spur64. This makes it easy to open Pharo images because you
      do not have to worry about which virtual machine variant is
      required.

      More about the Cog family of virtual machines:
        http://www.mirandabanda.org/cogblog/about-cog/
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

