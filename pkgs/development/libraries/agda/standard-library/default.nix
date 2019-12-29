{ stdenv, mkDerivation, fetchFromGitHub, ghcWithPackages }:

mkDerivation rec {
  pname = "standard-library";
  version = "1.1";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    sha256 = "190bxsy92ffmvwpmyyg3lxs91vyss2z25rqz1w79gkj56484cy64";
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
    maintainers = with maintainers; [ jwiegley mudri alexarice ];
  };
}
