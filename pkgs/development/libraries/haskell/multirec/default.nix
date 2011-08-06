{cabal} :

cabal.mkDerivation (self : {
  pname = "multirec";
  version = "0.5.1";
  sha256 = "0y62gb2ml0799a3f1ny5ydjc4rjwj1dgs48f5fj6hf2fpl4hk02l";
  noHaddock = true; # don't know why Haddock causes an error
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/Multirec";
    description = "Generic programming for families of recursive datatypes";
    license = self.stdenv.lib.licenses.bsd3;
  };
})
