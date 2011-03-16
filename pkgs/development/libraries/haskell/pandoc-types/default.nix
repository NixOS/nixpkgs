{cabal, syb}:

cabal.mkDerivation (self : {
  pname = "pandoc-types";
  version = "1.8";
  sha256 = "1ikr1dmmdag31hgcswrnhzqacv4kl7z6dc8za2cjdq0cpd2mla98";
  propagatedBuildInputs = [syb];
  meta = {
    description = "Types for representing a structured document";
  };
})
