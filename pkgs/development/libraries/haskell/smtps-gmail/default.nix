{ cabal, base64Bytestring, cprngAes, dataDefault, filepath
, mimeMail, network, stringsearch, text, tls
}:

cabal.mkDerivation (self: {
  pname = "smtps-gmail";
  version = "1.2.0";
  sha256 = "1gg3cglfsyfffh3b5cyrk3pnb8jg5s8s4yjzykdnfyjrdp1080xz";
  buildDepends = [
    base64Bytestring cprngAes dataDefault filepath mimeMail network
    stringsearch text tls
  ];
  meta = {
    homepage = "https://github.com/enzoh/smtps-gmail";
    description = "Gmail SMTP Client";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
