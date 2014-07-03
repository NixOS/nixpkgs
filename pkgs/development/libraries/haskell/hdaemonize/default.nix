{ cabal, extensibleExceptions, filepath, hsyslog, mtl }:

cabal.mkDerivation (self: {
  pname = "hdaemonize";
  version = "0.4.5.0";
  sha256 = "1b9aic08pgmp95qy74qcrmq9dn33k6knycy7mn1dg8c5svmchb2w";
  buildDepends = [ extensibleExceptions filepath hsyslog mtl ];
  meta = {
    homepage = "http://github.com/madhadron/hdaemonize";
    description = "Library to handle the details of writing daemons for UNIX";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
