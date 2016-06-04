{ stdenv, agda, fetchgit, ghcWithPackages }:

agda.mkDerivation (self: rec {
  version = "2.4.2.3";
  name = "agda-stdlib-${version}";

  src = fetchgit {
    url = "git://github.com/agda/agda-stdlib";
    rev = "9c9b3cb28f9a7d39a256890a1469c1a3f7fc4faf";
    sha256 = "1h64wzm4ysmq3gi33w3kp9h3f471sydpp453yf95bh5f713a8bxk";
  };

  nativeBuildInputs = [ (ghcWithPackages (self : [ self.filemanip ])) ];
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
