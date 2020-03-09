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
  ghcWithPackages = haskell.packages.ghc844.ghc.withPackages (g: (with g; [old-time regex-compat syb]));
in stdenv.mkDerivation rec {
  pname = "bluespec";
  version = "unstable-2020.02.09";

  src = fetchFromGitHub {
    owner  = "B-Lang-org";
    repo   = "bsc";
    rev    = "05c8afb08078e437c635b9c708124b428ac51b3d";
    sha256 = "06yhpkz7wga1a0p9031cfjqbzw7205bj2jxgdghhfzmllaiphniy";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  buildInputs = [
    zlib
    gmpStatic gperf libpoly # yices
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

  patches = [
    # drop stp support https://github.com/B-Lang-org/bsc/pull/31
    (fetchpatch {
      url = "https://github.com/flokli/bsc/commit/0bd48ecc2561541dc1368918863c0b2f4915006f.patch";
      sha256 = "0bam9anld33zfi9d4gs502g94w49zhl5iqmbs2d1p5i19aqpy38l";
    })
  ];

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
