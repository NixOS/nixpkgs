{ cabal, base64Bytestring, blazeHtml, cgi, ConfigFile, feed
, filepath, filestore, ghcPaths, happstackServer, highlightingKate
, hslogger, HStringTemplate, HTTP, json, mtl, network, pandoc
, pandocTypes, parsec, random, recaptcha, safe, SHA, syb, tagsoup
, text, time, url, utf8String, xhtml, xml, xssSanitize, zlib, fetchurl
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.10.3.1";
  sha256 = "1sm6rryfyqr0nd4flbc5d520xyw2ajnkylvqf4fi4dhl6fnbpam5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml cgi ConfigFile feed filepath filestore
    ghcPaths happstackServer highlightingKate hslogger HStringTemplate
    HTTP json mtl network pandoc pandocTypes parsec random recaptcha
    safe SHA syb tagsoup text time url utf8String xhtml xml xssSanitize
    zlib
  ];
  jailbreak = true;
  patches = [ (fetchurl { url = "https://github.com/jgm/gitit/commit/48155008397bdaed4f97c5678d83c70d4bc3f0ff.patch";
                          sha256 = "0xdg9frr8lany8ry6vj4vpskmhkpww8jswnb05pzl8a4xfqxh9gd";
                        })
            ];
  meta = {
    homepage = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
