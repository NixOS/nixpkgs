{ stdenv, agda, fetchFromGitHub, ghcWithPackages }:

agda.mkDerivation (self: rec {
  version = "0.16.1";
  name = "agda-stdlib-${version}";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    sha256 = "17dv5r3ygmbwwh7k8qaffp2965sv165b47i53ymc0gbfcwr6cy2n";
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
    maintainers = with maintainers; [ jwiegley fuuzetsu mudri ];
  };
})
