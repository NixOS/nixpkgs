{cabal, mtl, parsec, syb}:

cabal.mkDerivation (self : {
  pname = "WebBits";
  version = "1.0";
  sha256 = "1xqk4ajywlaq9nb9a02i7c25na5p2qbpc2k9zw93gbapppjiapsc";

  propagatedBuildInputs = [ mtl parsec syb ];

  meta = {
    description = "WebBits is a collection of libraries for working with JavaScript.";
  };
})
