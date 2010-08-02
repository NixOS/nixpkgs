{ stdenv, fetchurl, openexr, ilmbase, ctl }:

stdenv.mkDerivation {
  name = "openexr_ctl-1.0.1";

  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/ampasctl/openexr_ctl-1.0.1.tar.gz;
    sha256 = "1jg9smpaplal8l14djp184wzk11nwd3dvm4lhkp69kjgw8jdd21d";
  };

  propagatedBuildInputs = [ ilmbase ];
  
  buildInputs = [ openexr ctl ];
  
  configureFlags = "--with-ilmbase-prefix=${ilmbase}";

  meta = {
    description = "Color Transformation Language";
    homepage = http://ampasctl.sourceforge.net;
  };
}
