{cabal, mtl, network, parsec, xhtml}:

cabal.mkDerivation (self : {
  pname = "cgi";
  version = "3001.1.7.4"; # Haskell Platform 2011.2.0.0
  sha256 = "1fiild4djzhyz683kwwb0k4wvhd89ihbn6vncjl270xvwj5xmrbd";
  propagatedBuildInputs = [mtl network parsec xhtml];
  meta = {
    description = "A library for writing CGI programs";
  };
})

