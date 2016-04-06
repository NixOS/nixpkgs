{ stdenv, fetchurl, cmake, bash, unzip, glibc, openssl, gcc, mesa, freetype, xorg, alsaLib, cairo, makeDesktopItem } @args:

rec {
  pharo-vm-build = import ./build-vm.nix args;

  base-url = http://files.pharo.org/vm/src/vm-unix-sources/blessed;

  pharo-no-spur = pharo-vm-build rec {
    version = "2015.08.06";
    name = "pharo-vm-i386-${version}";
    binary-basename = "pharo-vm";
    src = fetchurl {
      url = "${base-url}/pharo-vm-${version}.tar.bz2";
      sha256 = "1kmb6phxb94d37awwldwbkj704l6m0c6sv0m54mcz6d4rx41fqgp";
    };
  };

  pharo-spur = pharo-vm-build rec {
    version = "2016.04.04";
    name = "pharo-vm-spur-i386-${version}";
    binary-basename = "pharo-spur-vm";
    src = fetchurl {
      url = "${base-url}/pharo-vm-spur-${version}.tar.bz2";
      sha256 = "1kmf782vdk9xbzi2yn1vpzksv8m04ry8n2ih16jhcihibxzcmz23";
    };
  };
}
