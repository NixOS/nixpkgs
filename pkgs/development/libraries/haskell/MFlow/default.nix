{ cabal, blazeHtml, blazeMarkup, caseInsensitive, clientsession
, conduit, conduitExtra, cpphs, extensibleExceptions, httpTypes
, monadloc, mtl, parsec, random, RefSerialize, stm, TCache, text
, time, transformers, utf8String, vector, wai, warp, warpTls
, Workflow
}:

cabal.mkDerivation (self: {
  pname = "MFlow";
  version = "0.4.5.4";
  sha256 = "1ih9ni14xmqvcfvayjkggmpmw3s9yzp17gf4xzygldmjcs35j4n3";
  buildDepends = [
    blazeHtml blazeMarkup caseInsensitive clientsession conduit
    conduitExtra extensibleExceptions httpTypes monadloc mtl parsec
    random RefSerialize stm TCache text time transformers utf8String
    vector wai warp warpTls Workflow
  ];
  buildTools = [ cpphs ];
  meta = {
    description = "stateful, RESTful web framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
