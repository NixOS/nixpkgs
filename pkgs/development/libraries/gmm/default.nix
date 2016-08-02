{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "gmm-4.3";

  src = fetchurl {
    url = http://download.gna.org/getfem/stable/gmm-4.3.tar.gz;
    sha256 = "0wpp3k73wd3rblsrwxl6djq6m11fx3q5wgw0pl41m9liswsw6din";
  };

  meta = { 
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = http://home.gna.org/getfem/gmm_intro.html;
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
