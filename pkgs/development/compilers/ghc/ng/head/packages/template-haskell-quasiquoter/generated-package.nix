{ mkDerivation, base, fetchzip, lib, template-haskell }:
mkDerivation {
  pname = "template-haskell-quasiquoter";
  version = "0.1.0.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/template-haskell-quasiquoter-0.1.0.0/template-haskell-quasiquoter-0.1.0.0.tar.gz";
    sha256 = "0pa65l0l03zy482dd50mry2p8b4gddlf04lhj963jz11538z4hzw";
  };
  libraryHaskellDepends = [ base template-haskell ];
  description = "The 'QuasiQuoter' interface";
  license = lib.meta.getLicenseFromSpdxId "BSD-2-Clause";
}
