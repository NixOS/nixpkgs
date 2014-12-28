{ stdenv, agda, fetchurl, ghc, filemanip }:

agda.mkDerivation (self: rec {
  version = "0.9";
  name = "Agda-stdlib-${version}";

  src = fetchurl {
    url = "https://github.com/agda/agda-stdlib/archive/v${version}.tar.gz";
    sha256 = "05rpmd2xra8wygq33mahdmijcjwq132l1akqyzj66n13frw4hfwj";
  };

  buildInputs = [ filemanip ghc ];
  preConfigure = ''
    runhaskell GenerateEverything.hs
  '';

  topSourceDirectories = [ "src" ];

  meta = with stdenv.lib; {
    homepage = "http://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "A standard library for use with the Agda compiler";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ jwiegley fuuzetsu ];
  };
})
