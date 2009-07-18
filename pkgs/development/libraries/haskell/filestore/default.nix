{cabal, datetime, parsec, regexPosix, split, time, utf8String, xml, Diff}:

cabal.mkDerivation (self : {
  pname = "filestore";
  version = "0.3.1";
  sha256 = "f18baafb50367d8d0a0e8da2873fd97033bb763d8776473e594c84c079017aa0";
  propagatedBuildInputs = [datetime parsec regexPosix split time utf8String xml Diff];
  meta = {
    description = "Interface for versioning file stores";
  };
})  

