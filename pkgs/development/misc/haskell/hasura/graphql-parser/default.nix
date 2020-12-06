{ mkDerivation, aeson, attoparsec, base, bytestring, containers
, criterion, fetchgit, filepath, hedgehog, hpack, prettyprinter
, protolude, regex-tdfa, scientific, stdenv, template-haskell, text
, text-builder, th-lift-instances, unordered-containers, vector
}:
mkDerivation {
  pname = "graphql-parser";
  version = "0.1.0.1";
  src = fetchgit {
    url = "https://github.com/hasura/graphql-parser-hs.git";
    sha256 = "sha256-oem/h0AQPk7eSM/P6wMoWV9KirxutE4hnQWwrpQ6TGk=";
    rev = "ba8e26fef1488cf3c8c08e86f02730f56ec84e1f";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson attoparsec base bytestring containers filepath hedgehog
    prettyprinter protolude regex-tdfa scientific template-haskell text
    text-builder th-lift-instances unordered-containers vector
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [
    aeson attoparsec base bytestring containers filepath hedgehog
    prettyprinter protolude regex-tdfa scientific template-haskell text
    text-builder th-lift-instances unordered-containers vector
  ];
  benchmarkHaskellDepends = [
    aeson attoparsec base bytestring containers criterion filepath
    hedgehog prettyprinter protolude regex-tdfa scientific
    template-haskell text text-builder th-lift-instances
    unordered-containers vector
  ];
  doCheck = false;
  prePatch = "hpack";
  homepage = "https://github.com/hasura/graphql-parser-hs#readme";
  license = stdenv.lib.licenses.bsd3;
}
