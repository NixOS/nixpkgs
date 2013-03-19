{ stdenv, fetchurl, ilmbase }:

stdenv.mkDerivation {
  name = "ctl-1.4.1";

  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/ampasctl/ctl-1.4.1.tar.gz;
    sha256 = "16lzgbpxdyhykdwndj1i9vx3h4bfkxqqcrvasvgg70gb5raxj0mj";
  };

  patches = [ ./patch.patch ./gcc47.patch ];

  propagatedBuildInputs = [ ilmbase ];

  configureFlags = "--with-ilmbase-prefix=${ilmbase}";

  #configurePhase = "
    #export CXXFLAGS=\"-I${ilmbase}/include -L${ilmbase}/lib\"
    #echo $CXXFLAGS
    #unset configurePhase; configurePhase
  #";

  meta = {
    description = "Color Transformation Language";
    homepage = http://ampasctl.sourceforge.net;
    license = "SOME OPEN SOURCE LICENSE"; # TODO which exactly is this?
  };

}
