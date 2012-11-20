{ cabal, gnuidn, gnutls, gsasl, libxmlSax, monadsTf, network, text
, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "network-protocol-xmpp";
  version = "0.4.4";
  sha256 = "0l2s412aazli80jszdl1am01z14a0q2z8fsxxjawk4cy70d6f4ry";
  buildDepends = [
    gnuidn gnutls gsasl libxmlSax monadsTf network text transformers
    xmlTypes
  ];
  jailbreak = true;
  meta = {
    homepage = "https://john-millikin.com/software/haskell-xmpp/";
    description = "Client library for the XMPP protocol";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
