{ buildDunePackage, mirage-block, logs }:

buildDunePackage rec {
  pname = "mirage-block-combinators";
  inherit (mirage-block) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ mirage-block logs ];

  meta = mirage-block.meta // {
    description = "Block signatures and implementations for MirageOS using Lwt";
    longDescription = ''
      This repo contains generic operations over Mirage `BLOCK` devices.
      This package is specialised to the Lwt concurrency library for IO.
    '';
  };

}
