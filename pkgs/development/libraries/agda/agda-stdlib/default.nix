{ stdenv, agda, fetchgit, ghcWithPackages }:

agda.mkDerivation (self: rec {
  version = "2.4.2.3";
  name = "agda-stdlib-${version}";

  src = fetchgit {
    url = "git://github.com/agda/agda-stdlib";
    rev = "451446c5d849b8c5d6d34363e3551169eb126cfb";
    sha256 = "40a55d3c22fb3462b110859f4cd63e79e086b25f23964b465768397b93c57701";
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
