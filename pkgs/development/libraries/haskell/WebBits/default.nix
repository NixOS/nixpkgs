{cabal, mtl, parsec, syb}:

cabal.mkDerivation (self : {
  pname = "WebBits";
  version = "2.0";
  sha256 = "14a1rqlq925f6rdbi8yx44xszj5pvskcmw1gi1bj8hbilgmlwi7f";

  propagatedBuildInputs = [ mtl parsec syb ];

  meta = {
    description = "WebBits is a collection of libraries for working with JavaScript.";
  };
})
