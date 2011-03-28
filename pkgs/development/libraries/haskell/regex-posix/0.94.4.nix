{cabal, regexBase}:

cabal.mkDerivation (self : {
  pname = "regex-posix";
  version = "0.94.4"; # Haskell Platform 2011.2.0.0
  sha256 = "1ykirysvz9ganm2k7fmrppklsgh0h35mjfsi9g1icv43pqpr6ldw";
  propagatedBuildInputs = [regexBase];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})

