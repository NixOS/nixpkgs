{
  lib,
  newScope,
  fetchurl,
}:
lib.makeScope newScope (self: {

  fetchegg =
    {
      pname,
      version,
      sha256,
      ...
    }:
    fetchurl {
      inherit sha256;
      url = "https://code.call-cc.org/egg-tarballs/6/${pname}/${pname}-${version}.tar.gz";
    };

  eggDerivation = self.callPackage ./eggDerivation.nix { };

  chicken = self.callPackage ./chicken.nix { };

})
