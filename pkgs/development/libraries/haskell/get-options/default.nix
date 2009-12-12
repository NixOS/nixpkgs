{cabal, fetchurl, sourceFromHead, mtl}:

cabal.mkDerivation (self : {
  pname = "get-options";
  version = "x"; # ? 
  name = self.fname;
  # REGION AUTO UPDATE:             { name="getOptions"; type="darcs"; url = "http://repetae.net/john/repos/GetOptions"; }
  src = sourceFromHead "getOptions-nrmtag1.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/getOptions-nrmtag1.tar.gz"; sha256 = "0e884687b2c676a5b7e79826a2236991cb045f794c5fd625813529a2b30224cd"; });
  # END
  extraBuildInputs = [ mtl ];
  meta = {
    description = "Simple to use get option library";
  };
})
