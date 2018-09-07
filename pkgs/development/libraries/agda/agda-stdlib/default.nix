{ stdenv, agda, fetchFromGitHub, ghcWithPackages }:

agda.mkDerivation (self: rec {
  version = "0.16";
  name = "agda-stdlib-${version}";

  src = fetchFromGitHub {
    repo = "agda-stdlib";
    owner = "agda";
    rev = "v${version}";
    sha256 = "0kqfx6742vbyyr8glqm5bkvj0z0y0dkaajlw10p3pzidrc17767r";
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
