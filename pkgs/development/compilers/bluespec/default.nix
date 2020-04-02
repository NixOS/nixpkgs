{ stdenv
, fetchFromGitHub
, fetchpatch
, autoconf
, automake
, fontconfig
, gmp
, gperf
, haskell
, libX11
, libpoly
, perl
, pkgconfig
, itktcl
, incrtcl
, tcl
, tk
, verilog
, xorg
, zlib
}:

let
  # yices wants a libgmp.a and fails otherwise
  gmpStatic = gmp.override { withStatic = true; };

  # Compiling PreludeBSV fails with more recent GHC versions
  # > imperative statement (not BVI context)
  # https://github.com/B-Lang-org/bsc/issues/20#issuecomment-583724030
  ghcWithPackages = haskell.packages.ghc844.ghc.withPackages (g: (with g; [old-time regex-compat syb split]));
in stdenv.mkDerivation rec {
  pname = "bluespec";
  version = "unstable-2020.04.03";

  src = fetchFromGitHub {
    owner  = "B-Lang-org";
    repo   = "bsc";
    rev    = "4c4509894388cd7a17fbd4fffab2f35572673539";
    sha256 = "1m51hagbvqv5kglhik1123rkv3fj57ybqispx8i7xm73rmcayinv";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  buildInputs = [
    zlib
    gmpStatic gperf libpoly # yices
    tcl tk
    libX11 # tcltk
    xorg.libXft
    fontconfig
  ];

  nativeBuildInputs = [
    automake autoconf
    perl
    pkgconfig
    ghcWithPackages
  ];

  checkInputs = [
    verilog
  ];

  NIX_LDFLAGS="-L${incrtcl}/lib -L${itktcl}/lib";

  preBuild = ''
    patchShebangs \
      src/Verilog/copy_module.pl \
      src/comp/update-build-version.sh \
      src/comp/update-build-system.sh \
      src/comp/wrapper.sh

    substituteInPlace src/comp/Makefile \
      --replace 'BINDDIR' 'BINDIR' \
      --replace 'install-bsc install-bluetcl' 'install-bsc install-bluetcl $(UTILEXES) install-utils'
  '';

  makeFlags = [
    "NOGIT=1" # https://github.com/B-Lang-org/bsc/issues/12
    "LDCONFIG=ldconfig" # https://github.com/B-Lang-org/bsc/pull/43
    "STP_STUB=1"
  ];

  installPhase = "mv inst $out";

  doCheck = true;

  meta = {
    description = "Toolchain for the Bluespec Hardware Definition Language";
    homepage    = "https://github.com/B-Lang-org/bsc";
    license     = stdenv.lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    # darwin fails at https://github.com/B-Lang-org/bsc/pull/35#issuecomment-583731562
    # aarch64 fails, as GHC fails with "ghc: could not execute: opt"
    maintainers = with stdenv.lib.maintainers; [ flokli thoughtpolice ];
  };
}
