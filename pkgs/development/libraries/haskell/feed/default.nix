{cabal, utf8String, xml}:

cabal.mkDerivation (self : {
  pname = "feed";
  version = "0.3.8";
  sha256 = "1yvigcvb8cvxfa8vb2i11xkrylqw57jwzkaji6m1wp03k80zf576";
  propagatedBuildInputs = [utf8String xml];
  meta = {
    description = "Interfacing with RSS and Atom feeds";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

