# This derivation is a reduced-functionality variant of Gambit stable,
# used to compile the full version of Gambit stable *and* unstable.

{ gccStdenv, lib, fetchurl, autoconf, gcc, coreutils, gambit-support, ... }:
# As explained in build.nix, GCC compiles Gambit 10x faster than Clang, for code 3x better

gccStdenv.mkDerivation {
  pname = "gambit-bootstrap";
  version = "4.9.3";

  src = fetchurl {
    url = "http://www.iro.umontreal.ca/~gambit/download/gambit/v4.9/source/gambit-v4_9_3.tgz";
    sha256 = "1p6172vhcrlpjgia6hsks1w4fl8rdyjf9xjh14wxfkv7dnx8a5hk";
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
