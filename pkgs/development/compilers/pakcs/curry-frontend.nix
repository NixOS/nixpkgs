{ mkDerivation, base, bytestring, Cabal, containers, curry-base
, directory, extra, file-embed, filepath, mtl, network-uri, pretty
, process, set-extra, lib, template-haskell, transformers
}:
mkDerivation {
  pname = "curry-frontend";
  version = "1.0.4";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base bytestring containers curry-base directory extra file-embed
    filepath mtl network-uri pretty process set-extra template-haskell
    transformers
  ];
  executableHaskellDepends = [
    base bytestring containers curry-base directory extra file-embed
    filepath mtl network-uri pretty process set-extra template-haskell
    transformers
  ];
  testHaskellDepends = [ base Cabal curry-base filepath ];
  homepage = "http://curry-language.org";
  description = "Compile the functional logic language Curry to several intermediate formats";
  license = lib.licenses.bsd3;
}
