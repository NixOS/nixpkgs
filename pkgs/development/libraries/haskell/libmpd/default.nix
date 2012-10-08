{ cabal, filepath, mtl, network, text, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.8.0.1";
  sha256 = "16j2c0dnwllsb979gqf1cl4ylvpldcj8k32ddpp4wf62lbb1mqxm";
  buildDepends = [ filepath mtl network text time utf8String ];
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
