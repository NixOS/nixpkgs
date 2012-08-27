{ cabal, cabalFileTh, cmdargs, filepath, haskeline, hledgerLib
, HUnit, mtl, parsec, regexpr, safe, shakespeareText, split, text
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.18.2";
  sha256 = "1i0rix3h5vrq9j01fzgwyhs2n8nfzhidi4rjlvn402ps0w6j15ld";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cabalFileTh cmdargs filepath haskeline hledgerLib HUnit mtl parsec
    regexpr safe shakespeareText split text time utf8String
  ];
  patchPhase = ''
    sed -i -e 's|,split.*|,split|' hledger.cabal
  '';
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
