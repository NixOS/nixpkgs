{cabal, binary, mtl}:

cabal.mkDerivation (self : {
  pname = "binary-shared";
  version = "0.8.1";
  sha256 = "0niq6hgsawsdg3kkjgkwyrgy8w7pfkqfph5d1x5bzcjrcl982jrg";
  propagatedBuildInputs = [binary mtl];
  meta = {
    description = "Binary serialization with support for sharing identical elements";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  
