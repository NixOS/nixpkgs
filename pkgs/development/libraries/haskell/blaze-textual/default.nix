{cabal, blazeBuilder, doubleConversion, text, vector}:

cabal.mkDerivation (self : {
  pname = "blaze-textual";
  version = "0.2.0.3";
  sha256 = "0x1a8qiqd4q6qlq2lf4v31wzsbrj7403p4zf74lfl7grjgvbsnfj";
  propagatedBuildInputs = [
    blazeBuilder doubleConversion text vector
  ];
  meta = {
    homepage = "http://github.com/mailrank/blaze-textual";
    description = "Fast rendering of common datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
