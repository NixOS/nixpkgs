{ cabal, binary, dataDefault, network, random, time }:

cabal.mkDerivation (self: {
  pname = "network-metrics";
  version = "0.3.2";
  sha256 = "14yf9di909443gkgaw7n262453d60pp9mw8vncmd6q7pywhdz9hh";
  buildDepends = [ binary dataDefault network random time ];
  meta = {
    homepage = "http://github.com/brendanhay/network-metrics";
    description = "Send metrics to Ganglia, Graphite, and statsd";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
