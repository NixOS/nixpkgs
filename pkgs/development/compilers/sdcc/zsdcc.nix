{ sdcc, fetchzip, ... }:
# https://www.z88dk.org/wiki/doku.php?id=temp:front#sdcc1

sdcc.overrideAttrs (oldAttrs: rec {
  name = "zsdcc-${oldAttrs.version}";

  patchrev = "a82f0ac5ed282038ba56ef490e6afcf1c3d38a63";

  patches = [(fetchzip {
    url = "https://github.com/z88dk/z88dk/raw/${patchrev}/libsrc/_DEVELOPMENT/sdcc_z88dk_patch.zip";
    sha256 = "0hnf0cyr5cgrv0scr5r5qlj3icdbl55icy6nic9bpz4vmdjpdcx7";
    # Removing Windows executables.
    extraPostFetch = ''
      rm $out/*.exe
      mkdir -p $out/sdcc
      mv $out/sdcc-z88dk.patch $out/sdcc'';
    stripRoot = false;
  })];

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
      "--disable-sdbinutils"
      "--disable-non-free"
    ];

    meta = oldAttrs.meta // {
      description = "SDCC with z88dk patches";
      /* maintainers = [ maintainers.genesis ]; */
  };
})
