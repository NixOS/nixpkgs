{ stdenv, agda, fetchFromGitHub, ghcWithPackages }:

agda.mkDerivation (self: rec {
  version = "2.5.1.1";
  name = "agda-stdlib-${version}";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    # The git hash from the std-lib subrepo from the Agda repository.
    rev = "2e32e924f4d9bc76edf00f6f00f04cf73dba3fb6";
    sha256 = "0j6k0sjrbc0kdh34xi3bqmk7m24aq102hwd11s8jwrl7p6znil3w";
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
    maintainers = with maintainers; [ jwiegley fuuzetsu mudri ];
  };
})
