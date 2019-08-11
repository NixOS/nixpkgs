{ stdenv, fetchsvn, cmake } :

let
  version = "0.8";

in stdenv.mkDerivation {
  name = "codec2-${version}";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/freetel/code/codec2/branches/${version}";
    sha256 = "0qbyaqdn37253s30n6m2ric8nfdsxhkslb9h572kdx18j2yjccki";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = http://www.rowetel.com/blog/?page_id=452;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ markuskowa ];
  };
}
