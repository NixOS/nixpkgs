{
  mkDerivation,
  algebraic-graphs,
  base,
  base64-bytestring,
  bytestring,
  case-insensitive,
  cereal,
  containers,
  crypton,
  directory,
  filepath,
  hspec,
  lib,
  lifted-base,
  monad-control,
  mtl,
  process,
  tasty,
  tasty-discover,
  tasty-hspec,
  tasty-hunit,
  tasty-quickcheck,
  temporary,
  text,
  unix,
  unordered-containers,
}:

mkDerivation {
  pname = "hnix-store-nar";
  version = "0.1.2.0";
  sha256 = "113cj9dhiw1fj4sdh954l0gpw4l9iycy2xj1ajx76brhsqxrh5r9";
  libraryHaskellDepends = [
    algebraic-graphs
    base
    bytestring
    case-insensitive
    cereal
    containers
    directory
    filepath
    lifted-base
    monad-control
    mtl
    text
    unix
    unordered-containers
  ];
  testHaskellDepends = [
    base
    base64-bytestring
    bytestring
    cereal
    containers
    crypton
    directory
    filepath
    hspec
    process
    tasty
    tasty-hspec
    tasty-hunit
    tasty-quickcheck
    temporary
    text
    unix
  ];
  testToolDepends = [ tasty-discover ];
  benchmarkHaskellDepends = [
    base
    bytestring
    directory
    filepath
  ];
  homepage = "https://github.com/haskell-nix/hnix-store";
  description = "NAR file format";
  license = lib.meta.getLicenseFromSpdxId "Apache-2.0";
}
