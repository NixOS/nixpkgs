{cabal, regexBase}:

cabal.mkDerivation (self : {
  pname = "regex-posix";
  version = "0.72.0.3"; # Haskell Platform 2009.0.0
  sha256 = "327ab87f3d4f5315a9414331eb382b8b997de8836d577c3f7d232c574606feb1";
  propagatedBuildInputs = [regexBase];
  meta = {
    description = "Replaces/Enhances Text.Regex";
  };
})

