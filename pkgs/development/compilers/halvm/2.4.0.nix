{ stdenv, fetchgit, bootPkgs, perl, gmp, ncurses, binutils, autoconf, alex, happy, makeStaticLibraries
, hscolour, xen, automake, gcc, git, zlib, libtool, enableIntegerSimple ? false
}:

stdenv.mkDerivation rec {
  version = "2.4.0";
  name = "HaLVM-${version}";
  isHaLVM = true;
  enableParallelBuilding = false;
  isGhcjs = false;
  src = fetchgit {
    rev = "65fad65966eb7e60f234453a35aeb564a09d2595";
    url = "https://github.com/GaloisInc/HaLVM";
    sha256 = "09633h38w0z20cz0wcfp9z5kzv8v1zwcv0wqvgq3c8svqbrxp28k";
  };
  prePatch = ''
    sed -i '305 d' Makefile
    sed -i '309,439 d' Makefile # Removes RPM packaging
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
  postInstall = ''
    patchShebangs $out/bin
    $out/bin/halvm-ghc-pkg recache
  '';
  passthru = {
    inherit bootPkgs;
    cross.config = "halvm";
    cc = "${gcc}/bin/gcc";
    ld = "${binutils}/bin/ld";
  };

  meta = {
    homepage = http://github.com/GaloisInc/HaLVM;
    description = "The Haskell Lightweight Virtual Machine (HaLVM): GHC running on Xen";
    platforms = ["x86_64-linux"];       # other platforms don't have Xen
    maintainers = with stdenv.lib.maintainers; [ dmjio ];
    inherit (bootPkgs.ghc.meta) license;
  };
}
