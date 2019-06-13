{stdenv, fetchurl, gmp}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lrs";
  version = "7.0";

  src = fetchurl {
    url = "http://cgm.cs.mcgill.ca/~avis/C/lrslib/archive/lrslib-070.tar.gz";
    sha256 = "1zjdmkjracz695k73c2pvipc0skpyn1wzagkhilsvcw9pqljpwg9";
  };

  buildInputs = [ gmp ];

  preBuild = ''
    export makeFlags="$makeFlags prefix=$out";
  '';

  meta = {
    inherit version;
    description = "Implementation of the reverse search algorithm for vertex enumeration/convex hull problems";
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://cgm.cs.mcgill.ca/~avis/C/lrs.html";
  };
}
