{ cabal, attoparsec, base16Bytestring, blazeBuilder, blazeTextual
, mysql, pcreLight, text, time
}:

cabal.mkDerivation (self: {
  pname = "mysql-simple";
  version = "0.2.2.4";
  sha256 = "044grjly1gyrgba2bfrii2pa14ff7v14ncyk3kj01g1zdxnwqjh6";
  buildDepends = [
    attoparsec base16Bytestring blazeBuilder blazeTextual mysql
    pcreLight text time
  ];
  meta = {
    homepage = "https://github.com/bos/mysql-simple";
    description = "A mid-level MySQL client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
