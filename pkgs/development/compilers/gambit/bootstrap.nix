# This derivation is a reduced-functionality variant of Gambit stable,
# used to compile the full version of Gambit stable *and* unstable.

{ gccStdenv, lib, fetchurl, autoconf, gcc, coreutils, gambit-support, ... }:
# As explained in build.nix, GCC compiles Gambit 10x faster than Clang, for code 3x better

gccStdenv.mkDerivation {
  pname = "gambit-bootstrap";
  version = "4.9.5";

  src = fetchurl {
    url = "https://gambitscheme.org/4.9.5/gambit-v4_9_5.tgz";
    sha256 = "sha256-4o74218OexFZcgwVAFPcq498TK4fDlyDiUR5cHP4wdw=";
  };

  buildInputs = [ autoconf ];

  configurePhase = ''
    export CC=${gcc}/bin/gcc CXX=${gcc}/bin/g++ \
           CPP=${gcc}/bin/cpp CXXCPP=${gcc}/bin/cpp LD=${gcc}/bin/ld \
           XMKMF=${coreutils}/bin/false
    unset CFLAGS LDFLAGS LIBS CPPFLAGS CXXFLAGS
    ./configure --prefix=$out/gambit
  '';

  buildPhase = ''
    # Copy the (configured) sources now, not later, so we don't have to filter out
    # all the intermediate build products.
    mkdir -p $out/gambit ; cp -rp . $out/gambit/

    # build the gsc-boot* compiler
    make -j$NIX_BUILD_CORES bootstrap
  '';

  installPhase = ''
    cp -fa ./gsc-boot $out/gambit/
  '';

  forceShare = [ "info" ];

  meta = gambit-support.meta // {
    description = "Optimizing Scheme to C compiler, bootstrap step";
  };
}
