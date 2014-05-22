{ cabal, async, caseInsensitive, cond, dataDefault, dyre, feed
, filepath, hslogger, httpConduit, httpTypes, lens, mimeMail
, monadControl, mtl, network, opml, random, resourcet, text
, textIcu, time, timerep, tls, transformers, transformersBase
, utf8String, xdgBasedir, xml
}:

cabal.mkDerivation (self: {
  pname = "imm";
  version = "0.6.0.1";
  sha256 = "11m6937wafl6nic69mbibrjnxib503907y21n9zmsxc8vnjl3pps";
  patches = [ ./latest-feed-http-conduit-tls.patch ];
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    async caseInsensitive cond dataDefault dyre feed filepath hslogger
    httpConduit httpTypes lens mimeMail monadControl mtl network opml
    random resourcet text textIcu time timerep tls transformers
    transformersBase utf8String xdgBasedir xml
  ];
  meta = {
    description = "Retrieve RSS/Atom feeds and write one mail per new item in a maildir";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ "Daniel Bergey <bergey@teallabs.org>" ];
  };
})