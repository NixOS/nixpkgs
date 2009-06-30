{cabal, utf8String, terminfo}:

cabal.mkDerivation (self : {
  pname = "vty";
  version = "3.1.8.4";
  sha256 = "9a006e77bb4f032613e059eea7bc4d92cbc7943449fb9c7269a061ddd9b3d82b";
  propagatedBuildInputs = [utf8String terminfo];
  meta = {
    description = "A simple terminal access library";
  };
})
