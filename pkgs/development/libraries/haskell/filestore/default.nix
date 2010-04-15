{cabal, datetime, parsec, regexPosix, split, time, utf8String, xml, Diff}:

cabal.mkDerivation (self : {
  pname = "filestore";
  version = "0.3.4.1";
  sha256 = "ad04333fae938ae7de747457a6bdee30c6e4b700733265dbd1f4f8ee363c8230";
  propagatedBuildInputs = [datetime parsec regexPosix split time utf8String xml Diff];
  meta = {
    description = "Interface for versioning file stores";
  };
})  

