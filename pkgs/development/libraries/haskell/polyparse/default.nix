{cabal, text}:

cabal.mkDerivation (self : {
  pname = "polyparse";
  version = "1.7";
  sha256 = "de8ed0ce54f1f81bb0783dd97b7b22eca28df4a238684a26b37c5af2d17a364b";
  propagatedBuildInputs = [text];
  meta = {
    description = "A variety of alternative parser combinator libraries";
  };
})

