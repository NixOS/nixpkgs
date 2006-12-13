{stdenv, fetchurl, unzip, ghc, wxGTK}:

stdenv.mkDerivation {
  name = "wxHaskell-0.9.4-1";
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/wxhaskell/wxhaskell-src-0.9.4-1.zip;
    md5 = "69c3876e1c8ed810cef9db7ed442cb89";
  };
  #builder = ./builder.sh;
  buildInputs = [unzip ghc wxGTK];
  installCommand = "make install-files";
#  inherit ghc;
}
