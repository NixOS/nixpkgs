{cabal, blazeBuilder, enumerator, transformers}:

cabal.mkDerivation (self : {
  pname = "blaze-builder-enumerator";
  version = "0.2.0.2";
  sha256 = "0as4mjh695jpxp9qfhpsxyr1448l0pk94sh5kk8sgxv5hfiy41k9";
  propagatedBuildInputs = [blazeBuilder enumerator transformers];
  meta = {
    description = "Enumeratees for the incremental conversion of builders to bytestrings";
    license = "BSD3";
  };
})
