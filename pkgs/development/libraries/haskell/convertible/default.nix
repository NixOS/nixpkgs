{cabal, mtl, time, text}:

cabal.mkDerivation (self : {
  pname = "convertible";
  version = "1.0.10.0";
  sha256 = "1phjxd40mfxzp2ma1yif5f2wrjqg21a5bwz05mh38lxrw68vm711";
  propagatedBuildInputs = [mtl time text];
  meta = {
    description = "Typeclasses and instances for converting between types";
  };
})

