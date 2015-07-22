{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wavpack-${version}";
  version = "4.75.0";

  enableParallelBuilding = true;

  preConfigure = ''
    sed -i '2iexec_prefix=@exec_prefix@' wavpack.pc.in
  '';

  src = fetchurl {
    url = "http://www.wavpack.com/${name}.tar.bz2";
    sha256 = "0bmgwcvch3cjcivk7pyasqysj0s81wkg40j3zfrcd7bl0qhmqgn6";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
