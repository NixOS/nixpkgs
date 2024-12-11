{
  mkDerivation,
  aeson,
  aeson-pretty,
  async,
  base,
  bytestring,
  directory,
  hspec,
  lens,
  lens-aeson,
  lib,
  optparse-applicative,
  process,
  protolude,
  QuickCheck,
  temporary,
  text,
  unix,
}:
mkDerivation {
  pname = "arion-compose";
  version = "0.2.2.0";
  sha256 = "55c7484b90b278fe502bda5feff67dec37a9bd64454a68e6e855277d96d73d67";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson
    aeson-pretty
    async
    base
    bytestring
    directory
    lens
    lens-aeson
    process
    protolude
    temporary
    text
    unix
  ];
  executableHaskellDepends = [
    aeson
    aeson-pretty
    async
    base
    bytestring
    directory
    lens
    lens-aeson
    optparse-applicative
    process
    protolude
    temporary
    text
    unix
  ];
  testHaskellDepends = [
    aeson
    aeson-pretty
    async
    base
    bytestring
    directory
    hspec
    lens
    lens-aeson
    process
    protolude
    QuickCheck
    temporary
    text
    unix
  ];
  homepage = "https://github.com/hercules-ci/arion#readme";
  description = "Run docker-compose with help from Nix/NixOS";
  license = lib.licenses.asl20;
  mainProgram = "arion";
}
