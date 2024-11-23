{ mkDerivation, base, binary, bytestring, Cabal, containers
, directory, extra, file-embed, filepath, lib, mtl, network-uri
, parsec, pretty, process, set-extra, template-haskell, time
, transformers
}:
mkDerivation {
  pname = "curry-frontend";
  version = "2.1.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base binary bytestring containers directory extra file-embed
    filepath mtl network-uri parsec pretty process set-extra
    template-haskell time transformers
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base bytestring Cabal containers directory extra file-embed
    filepath mtl network-uri pretty process set-extra template-haskell
    transformers
  ];
  homepage = "http://curry-language.org";
  description = "Compile the functional logic language Curry to several intermediate formats";
  license = lib.licenses.bsd3;
  mainProgram = "curry-frontend";
}
