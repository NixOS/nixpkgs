{ mkDerivation, base, fetchzip, lib }:
mkDerivation {
  pname = "xhtml";
  version = "3000.2.2.1";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/xhtml-3000.2.2.1/xhtml-3000.2.2.1.tar.gz";
    sha256 = "0qijjlg7cww6ykg5agdi3a4s5khr647yyr64v06xfjibm6zkq6ga";
  };
  libraryHaskellDepends = [ base ];
  homepage = "https://github.com/haskell/xhtml";
  description = "An XHTML combinator library";
  license = lib.licenses.bsd3;
}
