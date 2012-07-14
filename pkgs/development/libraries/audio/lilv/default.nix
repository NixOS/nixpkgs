{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord, sratom }:

stdenv.mkDerivation rec {
  name = "lilv-${version}";
  version = "0.14.2";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0g9sg5f8xkkvsad0c6rh4j1k2b2hwsh83yg66f4qznxh43np7zlx";
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

  };
}
