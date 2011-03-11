{cabal, WebBits}:

cabal.mkDerivation (self : {
  pname = "WebBits-Html";
  version = "1.0.1";
  sha256 = "134rmm5ccfsjdr0pdwn2mf81l81rgxapa3wjjfjkxrkxq6hav35n";

  propagatedBuildInputs = [ WebBits ];

  meta = {
    description = "WebBits is a collection of libraries for working with JavaScript embeded in HTML files.";
  };
})
