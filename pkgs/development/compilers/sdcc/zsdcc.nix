{ stdenv, sdcc, fetchFromGitHub, ... }:
# https://www.z88dk.org/wiki/doku.php?id=temp:front#sdcc1
# https://github.com/z88dk/z88dk/blob/master/src/zsdcc/readme.md

sdcc.overrideAttrs (oldAttrs: rec {
  version = "20180224";
  name = "zsdcc-Unstable-${version}"; # ${oldAttrs.version}

  meta = oldAttrs.meta // {
    description = "SDCC with z88dk patches";
    maintainers = with stdenv.lib.maintainers; [ genesis ];
  };

  src = fetchFromGitHub {
    owner = "z88dk";
    repo = "zsdcc";
    rev = "f914e938ee8bf7849d9b0883206a67c7b9dcc560";
    sha256 = "04q750q3y3hl2wilapwhiwrz6i4sl8p76jiy64520cyr71rbf0vh";
  };

  preConfigure = "cd sdcc";
  makeFlags = [ "sdcc-cc" ];

  # we need only Z80
  configureFlags = [
      "--disable-mcs51-port"
      "--disable-z180-port"
      "--disable-r2k-port"
      "--disable-r3ka-port"
      "--disable-gbz80-port"
      "--disable-tlcs90-port"
      "--disable-ds390-port"
      "--disable-ds400-port"
      "--disable-pic14-port"
      "--disable-pic16-port"
      "--disable-hc08-port"
      "--disable-s08-port"
      "--disable-stm8-port"
      "--disable-ucsim"
      "--disable-device-lib"
      "--disable-packihx"
      "--disable-sdcdb"
      "--disable-non-free"
    ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/sdcpp $out/bin/zsdcpp
    cp bin/sdcc  $out/bin/zsdcc
  '';
})
