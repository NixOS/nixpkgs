{cabal, pcre}:

cabal.mkDerivation (self : {
  pname = "pcre-light";
  version = "0.4";
  sha256 = "1xiikiap1bvx9czw64664vifdq64scx0yhfclh5m8mkvn3x6yzxk";
  propagatedBuildInputs = [pcre];
  meta = {
    description = "A small, efficient and portable regex library for Perl 5 compatible regular expressions";
  };
})

