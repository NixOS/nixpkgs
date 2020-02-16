{ stdenv, fetchurl, autoconf, gcc, coreutils, ... }:

stdenv.mkDerivation {
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
    ./configure --prefix=$out
  '';

  buildPhase = ''
    # Copy the (configured) sources now, not later, so we don't have to filter out
    # all the intermediate build products.
    mkdir -p $out ; cp -rp . $out/

    # build the gsc-boot* compiler
    make bootstrap
  '';

  installPhase = ''
    cp -fa ./ $out/
  '';

  forceShare = [ "info" ];

  meta = {
    description = "Optimizing Scheme to C compiler, bootstrap step";
    homepage    = "http://gambitscheme.org";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice raskin fare ];
  };
}
