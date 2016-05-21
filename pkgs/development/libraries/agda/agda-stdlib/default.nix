{ stdenv, agda, fetchurl, ghcWithPackages }:

agda.mkDerivation (self: rec {
  version = "v0.12";
  name = "agda-stdlib-${version}";

  src = fetchurl {
    url = "https://github.com/agda/agda-stdlib/archive/${version}.tar.gz";
    sha256 = "11qf87hxx3g0n8i6nkp4vqvh3i0gal6g812p0w2n4k7711nvrp9g";
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
