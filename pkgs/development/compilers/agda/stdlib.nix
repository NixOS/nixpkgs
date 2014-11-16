{ stdenv, agda, fetchurl, ghc, filemanip }:

agda.mkDerivation (self: rec {
  name = "Agda-stdlib";
  version = "0.8.1";

  src = fetchurl {
    url = "https://github.com/agda/agda-stdlib/archive/v${version}.tar.gz";
    sha256 = "0ij4rg4lk0pq01ing285gbmnn23dcf2rhihdcs8bbdpjg52vl4gf";
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
