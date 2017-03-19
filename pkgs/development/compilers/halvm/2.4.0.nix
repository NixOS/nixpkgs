{ stdenv, fetchgit, bootPkgs, perl, gmp, ncurses, binutils, autoconf, alex, happy, makeStaticLibraries
, hscolour, xen, automake, gcc, git, zlib, libtool, enableIntegerSimple ? false
}:

stdenv.mkDerivation rec {
  version = "2.4.0";
  name = "HaLVM-${version}";
  isHaLVM = true;
  isGhcjs = false;
  src = fetchgit {
    rev = "6aa72c9b047fd8ddff857c994a5a895461fc3925";
    url = "https://github.com/GaloisInc/HaLVM";
    sha256 = "05cg4w6fw5ajmpmh8g2msprnygmr4isb3pphqhlddfqwyvqhl167";
  };
  prePatch = ''
    sed -i '312 d' Makefile
    sed -i '316,446 d' Makefile # Removes RPM packaging
    sed -i '20 d' src/scripts/halvm-cabal.in
    sed -ie 's|ld |${binutils}/bin/ld |g' src/scripts/ldkernel.in
  '';
  configureFlags = stdenv.lib.optional (!enableIntegerSimple) [ "--enable-gmp" ];
  propagatedNativeBuildInputs = [ alex happy ];
  buildInputs =
   let haskellPkgs = [ alex happy bootPkgs.hscolour bootPkgs.cabal-install bootPkgs.haddock bootPkgs.hpc
    ]; in [ bootPkgs.ghc
            automake perl git binutils
            autoconf xen zlib ncurses.dev
            libtool gmp ] ++ haskellPkgs;
  preConfigure = ''
    autoconf
    patchShebangs .
  '';
  hardeningDisable = ["all"];
  postInstall = "$out/bin/halvm-ghc-pkg recache";
  passthru = {
    inherit bootPkgs;
    cross.config = "halvm";
    cc = "${gcc}/bin/gcc";
    ld = "${binutils}/bin/ld";
  };

  meta = {
    homepage = "http://github.com/GaloisInc/HaLVM";
    description = "The Haskell Lightweight Virtual Machine (HaLVM): GHC running on Xen";
    maintainers = with stdenv.lib.maintainers; [ dmjio ];
    inherit (bootPkgs.ghc.meta) license platforms;
  };
}
