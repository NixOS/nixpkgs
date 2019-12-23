{ stdenv, agda, fetchFromGitHub, ghcWithPackages }:

agda.mkDerivation (self: rec {
  version = "1.2";
  name = "agda-stdlib-${version}";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    sha256 = "01v4dy0ckir9skrn118ca4mzjnwdas70q9a9lncawjblwzikg4hq";
  };

  nativeBuildInputs = [ (ghcWithPackages (self : [ self.filemanip ])) ];
  preConfigure = ''
    runhaskell GenerateEverything.hs
  '';

  topSourceDirectories = [ "src" ];

  meta = with stdenv.lib; {
    homepage = http://wiki.portal.chalmers.se/agda/pmwiki.php?n=Libraries.StandardLibrary;
    description = "A standard library for use with the Agda compiler";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ jwiegley mudri ];
  };
})
