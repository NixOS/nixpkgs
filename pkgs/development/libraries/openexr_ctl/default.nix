args:
args.stdenv.mkDerivation {
  name = "openexr_ctl-1.0.1";

  src = args.fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/ampasctl/openexr_ctl-1.0.1.tar.gz;
    sha256 = "1jg9smpaplal8l14djp184wzk11nwd3dvm4lhkp69kjgw8jdd21d";
  };

  propagatedBuildInputs = (with args; [ilmbase]);
  buildInputs = ( with args; [openexr ctl]);
  configureFlags="--with-ilmbase-prefix=${args.ilmbase}";
  #configurePhase = "
    #export CXXFLAGS=\"-I${args.ilmbase}/include -L${args.ilmbase}/lib\"
    #echo $CXXFLAGS
    #unset configurePhase; configurePhase
  #";

  meta = {
      description = "Color Transformation Language";
      homepage = http://ampasctl.sourceforge.net;
      license = "SOME OPEN SOURCE LICENSE"; # TODO which exactly is this?
  };
}
