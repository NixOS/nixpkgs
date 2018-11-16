{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "gecode-${version}";
  version = "6.0.0";

  src = fetchurl {
    url = "http://www.gecode.org/download/${name}.tar.gz";
    sha256 = "0dp7bm6k790jx669y4jr0ffi5cdfpwsqm1ykj2c0zh56jsgs6hfs";
  };

  enableParallelBuilding = true;
  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = http://www.gecode.org;
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ maintainers.manveru ];
  };
}
