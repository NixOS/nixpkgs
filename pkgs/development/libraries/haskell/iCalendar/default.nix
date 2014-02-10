{ cabal, base64Bytestring, caseInsensitive, dataDefault, mime, mtl
, network, parsec, text, time
}:

cabal.mkDerivation (self: {
  pname = "iCalendar";
  version = "0.4";
  sha256 = "1wjgrgm4m21fic7a83k5jql4jxknk7mhh3shhrgb2kvxrj0bfw8b";
  buildDepends = [
    base64Bytestring caseInsensitive dataDefault mime mtl network
    parsec text time
  ];
  meta = {
    homepage = "http://github.com/tingtun/iCalendar";
    description = "iCalendar data types, parser, and printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
