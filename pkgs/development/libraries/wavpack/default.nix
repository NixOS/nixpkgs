{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wavpack-${version}";
  version = "4.70.0";

  src = fetchurl {
    url = "http://www.wavpack.com/${name}.tar.bz2";
    sha256 = "191h8hv8qk72hfh1crg429i9yq3cminwqb249sy9zadbn1wy7b9c";
  };

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ codyopel ];
  };
}
