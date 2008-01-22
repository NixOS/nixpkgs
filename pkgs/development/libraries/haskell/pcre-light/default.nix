{cabal, pcre}:

cabal.mkDerivation (self : {
  pname = "pcre-light";
  version = "0.3";
  sha256 = "a8cfec1c265530388efbb187426368e280331d9829fa93d8f49f16db3c3e7794";
  propagatedBuildInputs = [pcre];
  meta = {
    description = "A small, efficient and portable regex library for Perl 5 compatible regular expressions";
  };
})  

