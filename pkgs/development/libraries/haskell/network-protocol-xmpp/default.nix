{ cabal, gnuidn, gnutls, gsasl, libxmlSax, monadsTf, network, text
, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "network-protocol-xmpp";
  version = "0.4.5";
  sha256 = "1phnd9nygpc8gmyriwaqjnvygxi5zg4nx2i1m3vwwxql221420gg";
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
