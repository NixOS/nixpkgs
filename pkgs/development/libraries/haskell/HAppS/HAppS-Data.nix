{cabal, mtl, sybWithClass, HaXml, HAppSUtil, bytestring, binary}:

cabal.mkDerivation (self : {
    pname = "HAppS-Data";
    version = "0.9.3";
    sha256 = "b23c6f4a949927194e47f9781edc3b7d38513210de4a24987859d68b375bc335";
    propagatedBuildInputs = [mtl sybWithClass HaXml HAppSUtil bytestring binary];
    meta = {
        description = ''HAppS data manipulation libraries'';
        longDescription = ''
          This package provides libraries for:

            * Deriving instances for your datatypes.

            * Producing default values of Haskell datatypes.

            * Normalizing values of Haskell datatypes.

            * Marshalling Haskell values to and from XML.

            * Marshalling Haskell values to and from HTML forms.
        '';
        license = "free";
    };
})
