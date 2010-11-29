{cabal, transformers}:

cabal.mkDerivation (self : {
  pname = "multiplate";
  version = "0.0.1";
  sha256 = "06bdj0r83arxxl6vqif9dmna140qcgvjizcyhvyqymsid605hrp4";
  propagatedBuildInputs = [transformers];
  meta = {
    description = "Lightweight generic library for mutually recursive datatypes";
    license = "MIT";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

