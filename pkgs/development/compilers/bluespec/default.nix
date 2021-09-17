{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, fontconfig
, libX11
, perl
, flex
, bison
, pkg-config
, tcl
, tk
, xorg
, yices
, zlib
, ghc
, gmp-static
, verilog
, asciidoctor
, tex }:

let
  ghcWithPackages = ghc.withPackages (g: (with g; [ old-time regex-compat syb split ]));

in stdenv.mkDerivation rec {
  pname = "bluespec";
  version = "2021.07";

  src = fetchFromGitHub {
    owner = "B-Lang-org";
    repo = "bsc";
    rev = version;
    sha256 = "0gw8wyp65lpkyfhv3laazz9qypdl8qkp1j7cqp0gv11592a9p5qw";
  };

  enableParallelBuilding = true;

  outputs = [ "out" "doc" ];

  # https://github.com/B-Lang-org/bsc/pull/278
  patches = [ ./libstp_stub_makefile.patch ];

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
    export LD_LIBRARY_PATH=$PWD/inst/lib/SAT
  '';

  buildInputs = yices.buildInputs ++ [
    fontconfig
    libX11 # tcltk
    tcl
    tk
    xorg.libXft
    zlib
  ];

  nativeBuildInputs = [
    automake
    autoconf
    asciidoctor
    bison
    flex
    ghcWithPackages
    perl
    pkg-config
    tex
  ];

  makeFlags = [
    "release"
    "NO_DEPS_CHECKS=1" # skip the subrepo check (this deriviation uses yices.src instead of the subrepo)
    "NOGIT=1" # https://github.com/B-Lang-org/bsc/issues/12
    "LDCONFIG=ldconfig" # https://github.com/B-Lang-org/bsc/pull/43
    "STP_STUB=1"
  ];

  doCheck = true;

  checkInputs = [
    gmp-static
    verilog
  ];

  checkTarget = "check-smoke";

  installPhase = ''
    mkdir -p $out
    mv inst/bin $out
    mv inst/lib $out

    # fragile, I know..
    mkdir -p $doc/share/doc/bsc
    mv inst/README $doc/share/doc/bsc
    mv inst/ReleaseNotes.* $doc/share/doc/bsc
    mv inst/doc/*.pdf $doc/share/doc/bsc
  '';

  meta = {
    description = "Toolchain for the Bluespec Hardware Definition Language";
    homepage = "https://github.com/B-Lang-org/bsc";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    # darwin fails at https://github.com/B-Lang-org/bsc/pull/35#issuecomment-583731562
    # aarch64 fails, as GHC fails with "ghc: could not execute: opt"
    maintainers = with lib.maintainers; [ jcumming thoughtpolice ];
  };
}
