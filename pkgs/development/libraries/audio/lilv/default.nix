{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "lilv-${version}";
  version = "0.20.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0aj2plkx56iar8vzjbq2l7hi7sp0ml99m0h44rgwai2x4vqkk2j2";
  };

  buildInputs = [ lv2 pkgconfig python serd sord sratom ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/lilv;
    description = "A C library to make the use of LV2 plugins";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
