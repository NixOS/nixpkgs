{ stdenv, fetchsvn, lv2, pkgconfig, python, serd, sord-svn, sratom }:

stdenv.mkDerivation rec {
  name = "lilv-svn-${rev}";
  rev = "5675";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/lilv";
    rev = rev;
    sha256 = "1wr61sivgbh0j271ix058sncsrgh9p2rh7af081s2z9ml8szgraq";
  };

  buildInputs = [ lv2 pkgconfig python serd sord-svn sratom ];

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
