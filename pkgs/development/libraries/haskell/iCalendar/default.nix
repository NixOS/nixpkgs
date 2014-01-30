{ cabal, base64Bytestring, caseInsensitive, dataDefault, mime, mtl
, network, parsec, text, time
}:

cabal.mkDerivation (self: {
  pname = "iCalendar";
  version = "0.3.0.1";
  sha256 = "0d51rb46vcpb05vsqqmk3w7rymybl3vz8cqs0pw088a52kiy4xc3";
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
