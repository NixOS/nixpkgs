{ mkDerivation, base, bytestring, deepseq, directory, filepath, lib
, unix
}:
mkDerivation {
  pname = "process";
  version = "1.6.13.1";
  sha256 = "475a4ac288822c7d4ba6ed33641c941e1209165ededfb675be859394d5556aba";
  revision = "1";
  editedCabalFile = "0lyki037px8ikiw282l8a774n5fxa9lbbcw12dvjvxrzk5y8pfy8";
  libraryHaskellDepends = [ base deepseq directory filepath unix ];
  testHaskellDepends = [ base bytestring directory ];
  description = "Process libraries";
  license = lib.licenses.bsd3;
}
