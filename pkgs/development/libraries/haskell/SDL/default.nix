{cabal, SDL}:

cabal.mkDerivation (self : {
  pname = "SDL";
  version = "0.5.5";
  sha256 = "cc56c723e03befd99be0a293347690ba7d2cb7fdafcbbc287f067a8cf70af172";
  propagatedBuildInputs = [SDL];
  meta = {
    description = "Binding to libSDL";
  };
})

