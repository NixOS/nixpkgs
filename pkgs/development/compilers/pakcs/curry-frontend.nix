{ mkDerivation, base, Cabal, containers, curry-base, directory
, extra, filepath, mtl, network-uri, pretty, process, set-extra
, stdenv, transformers
}:
mkDerivation {
  pname = "curry-frontend";
  version = "1.0.2";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base containers curry-base directory extra filepath mtl network-uri
    pretty process set-extra transformers
  ];
  executableHaskellDepends = [
    base containers curry-base directory extra filepath mtl network-uri
    pretty process set-extra transformers
  ];
  testHaskellDepends = [ base Cabal curry-base filepath ];
  homepage = "http://curry-language.org";
  description = "Compile the functional logic language Curry to several intermediate formats";
  license = stdenv.lib.licenses.bsd3;
}
