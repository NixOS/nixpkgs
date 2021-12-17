{ buildDunePackage, fetchpatch, mirage-block, io-page, logs }:

buildDunePackage rec {
  pname = "mirage-block-combinators";
  inherit (mirage-block) version src useDune2;

  patches = [
    (fetchpatch {
      name = "cstruct-6.0.0-compat.patch";
      url = "https://github.com/mirage/mirage-block/pull/49/commits/ff54105b21fb32d0d6977b419db0776e6c2ea166.patch";
      sha256 = "0bwgypnsyn4d9b46q6r7kh5qfcy58db7krs6z5zw83hc7y20y2sd";
    })
  ];

  propagatedBuildInputs = [ mirage-block io-page logs ];

  meta = mirage-block.meta // {
    description = "Block signatures and implementations for MirageOS using Lwt";
    longDescription = ''
      This repo contains generic operations over Mirage `BLOCK` devices.
      This package is specialised to the Lwt concurrency library for IO.
    '';
  };

}
