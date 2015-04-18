{ stdenv, lib, fetchcvs, cmake, libtool, automake, autoconf }:

stdenv.mkDerivation rec {
  name = "libtidy-${version}";

  version = "1.46";

  src = fetchcvs {
    cvsRoot = ":pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy";
    module  = "tidy";
    date    = "2009-03-25";
    sha256  = "0bnxn1qgjx1pfyn2q4y24yj1gwqq5bxwf5ksjljqzqzrmjv3q46x";
  };

  preConfigure = ''
    source build/gnuauto/setup.sh
  '';

  buildInputs = [ libtool automake autoconf ];

  meta = with lib; {
    description = "Validate, correct, and pretty-print HTML files";
    homepage    = http://tidy.sourceforge.net;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
