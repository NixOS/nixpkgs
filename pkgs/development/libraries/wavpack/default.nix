{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wavpack-${version}";
  version = "4.70.0";

  enableParallelBuilding = true;

  preConfigure = ''
    sed -i '2iexec_prefix=@exec_prefix@' wavpack.pc.in
  '';

  src = fetchurl {
    url = "http://www.wavpack.com/${name}.tar.bz2";
    sha256 = "191h8hv8qk72hfh1crg429i9yq3cminwqb249sy9zadbn1wy7b9c";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
