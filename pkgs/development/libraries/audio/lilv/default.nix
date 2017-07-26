{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "lilv-${version}";
  version = "0.24.2";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "08m5a372pr1l7aii9s3pic5nm68gynx1n1bc7bnlswziq6qnbv7p";
  };

  buildInputs = [ lv2 pkgconfig python serd sord sratom ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/lilv;
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
