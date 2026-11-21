{
  mkDerivation,
  base,
  fetchzip,
  lib,
  ncurses,
}:
mkDerivation {
  pname = "terminfo";
  version = "0.4.1.7";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/terminfo-0.4.1.7/terminfo-0.4.1.7.tar.gz";
    sha256 = "1ndqpyjyl3i67bhcb0q0bi1v3wwv0hia1gg5449jpri1dd81as1v";
  };
  libraryHaskellDepends = [ base ];
  librarySystemDepends = [ ncurses ];
  homepage = "https://github.com/judah/terminfo";
  description = "Haskell bindings to the terminfo library";
  license = lib.licenses.bsd3;
}
