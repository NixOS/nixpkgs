{ cabal, primitive, fetchgit }:

cabal.mkDerivation (self: {
  pname = "ghcjs-prim";
  version = "0.1.0.0";
  src = fetchgit {
    url = git://github.com/ghcjs/ghcjs-prim.git;
    rev = "8e003e1a1df10233bc3f03d7bbd7d37de13d2a84";
    sha256 = "11k2r87s58wmpxykn61lihn4vm3x67cm1dygvdl26papifinj6pz";
  };
  buildDepends = [ primitive ];
})
