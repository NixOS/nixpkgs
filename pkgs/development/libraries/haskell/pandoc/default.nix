{cabal, HTTP, base64Bytestring, citeprocHs, dlist, json, mtl,
 network, pandocTypes, parsec, syb, tagsoup, texmath, utf8String,
 xhtml, xml, zipArchive} :

cabal.mkDerivation (self : {
  pname = "pandoc";
  version = "1.8.2.1";
  sha256 = "0cwly0j2rj46h654iwl04l6jkhk6rrhynqvrdnq47067n9vm60pi";
  propagatedBuildInputs = [
    HTTP base64Bytestring citeprocHs dlist json mtl network pandocTypes
    parsec syb tagsoup texmath utf8String xhtml xml zipArchive
  ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Conversion between markup formats";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
