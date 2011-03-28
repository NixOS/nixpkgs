{cabal, datetime, parsec, regexPosix, split, time, utf8String, xml, Diff}:

cabal.mkDerivation (self : {
  pname = "filestore";
  version = "0.4.0.3";
  sha256 = "098z9niavzxfzwk40xabah3x06vdzprvsjkyx99wlmapi5rynfz3";
  propagatedBuildInputs = [datetime parsec regexPosix split time utf8String xml Diff];
  meta = {
    description = "Interface for versioning file stores";
  };
})

