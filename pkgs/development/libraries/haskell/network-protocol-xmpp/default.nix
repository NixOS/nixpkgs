{ cabal, gnuidn, gnutls, gsasl, libxmlSax, monadsTf, network, text
, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "network-protocol-xmpp";
  version = "0.4.6";
  sha256 = "0xmafjz11v2dlbyg2ny90ycz315s23yprdpxz3l06igjxw6h3v6n";
  buildDepends = [
    gnuidn gnutls gsasl libxmlSax monadsTf network text transformers
    xmlTypes
  ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-xmpp/";
    description = "Client library for the XMPP protocol";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
