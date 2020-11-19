{ stdenv, mkDerivation, fetchFromGitHub, ghcWithPackages }:

mkDerivation rec {
  pname = "standard-library";
  version = "1.4";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    sha256 = "1asjbisb7pfkgzqy7gf9b23z63bba8l8p1wqfd6ff5ddgqwj3dhp";
  };

  nativeBuildInputs = [ (ghcWithPackages (self : [ self.filemanip ])) ];
  preConfigure = ''
    runhaskell GenerateEverything.hs
  '';

  meta = with stdenv.lib; {
    homepage = "https://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary";
    description = "A standard library for use with the Agda compiler";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ jwiegley mudri alexarice turion ];
  };
}
