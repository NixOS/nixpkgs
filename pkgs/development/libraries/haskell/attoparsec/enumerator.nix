{cabal, attoparsec, enumerator}:

cabal.mkDerivation (self : {
  pname = "attoparsec-enumerator";
  version = "0.2.0.3";
  sha256 = "02v9cwq1jbn0179zd2cky4ix6ykrkd7cpw38c1x7zgy0pal42x4v";
  propagatedBuildInputs = [attoparsec enumerator];
  meta = {
    description = "Converts an Attoparsec parser into an iteratee";
    license = "BSD3";
  };
})

