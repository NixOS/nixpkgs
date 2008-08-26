{cabal, haxr, HaXml, HTTP}:

cabal.mkDerivation (self : {
  pname = "haxr-th";
  version = "3000.0.0";
  sha256 = "00wqhri2fljjds6rwws0hgk7z27ii1lgvxr8db2li0780q5fa6ic";
  meta = {
    description = "Automatic deriving of XML-RPC structs for Haskell records.";
  };
  propagatedBuildInputs = [HaXml HTTP haxr];
})
