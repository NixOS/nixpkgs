{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, autoconf
, automake
, fontconfig
, gmp-static
, gperf
, libX11
, libpoly
, perl
, flex
, bison
, pkg-config
, itktcl
, incrtcl
, tcl
, tk
, verilog
, xorg
, yices
, zlib
, ghc
}:

let
  ghcWithPackages = ghc.withPackages (g: (with g; [old-time regex-compat syb split ]));
in stdenv.mkDerivation rec {
  pname = "bluespec";
  version = "unstable-2020.11.04";

  src = fetchFromGitHub {
      owner  = "B-Lang-org";
      repo   = "bsc";
      rev    = "103357f32cf63f2ca2b16ebc8e2c675ec5562464";
      sha256 = "0iikzx0fxky0fmc31lyxfldy1wixr2mayzcn24b8d76wd4ix1vk3";
    };

  enableParallelBuilding = true;

  patches = [ ./libstp_stub_makefile.patch ];

  buildInputs = yices.buildInputs ++ [
    zlib
    tcl tk
    libX11 # tcltk
    xorg.libXft
    fontconfig
  ];

  nativeBuildInputs = [
    automake autoconf
    perl
    flex
    bison
    pkg-config
    ghcWithPackages
  ];

  checkInputs = [
    verilog
  ];


  postUnpack = ''
    mkdir -p $sourceRoot/src/vendor/yices/v2.6/yices2
    # XXX: only works because yices.src isn't a tarball.
    cp -av ${yices.src}/* $sourceRoot/src/vendor/yices/v2.6/yices2
    chmod -R +rwX $sourceRoot/src/vendor/yices/v2.6/yices2
  '';

  preBuild = ''
    patchShebangs \
      src/Verilog/copy_module.pl \
      src/comp/update-build-version.sh \
      src/comp/update-build-system.sh \
      src/comp/wrapper.sh

    substituteInPlace src/comp/Makefile \
      --replace 'BINDDIR' 'BINDIR' \
      --replace 'install-bsc install-bluetcl' 'install-bsc install-bluetcl $(UTILEXES) install-utils'
    # allow running bsc to bootstrap
    export LD_LIBRARY_PATH=/build/source/inst/lib/SAT
  '';

  makeFlags = [
    "NO_DEPS_CHECKS=1" # skip the subrepo check (this deriviation uses yices.src instead of the subrepo)
    "NOGIT=1" # https://github.com/B-Lang-org/bsc/issues/12
    "LDCONFIG=ldconfig" # https://github.com/B-Lang-org/bsc/pull/43
    "STP_STUB=1"
  ];

  installPhase = "mv inst $out";

  doCheck = true;

  meta = {
    description = "Toolchain for the Bluespec Hardware Definition Language";
    homepage    = "https://github.com/B-Lang-org/bsc";
    license     = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    # darwin fails at https://github.com/B-Lang-org/bsc/pull/35#issuecomment-583731562
    # aarch64 fails, as GHC fails with "ghc: could not execute: opt"
    maintainers = with lib.maintainers; [ jcumming thoughtpolice ];
  };
}
