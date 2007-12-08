args:
args.stdenv.mkDerivation {
  name = "ctl-1.4.1";

  src = args.fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/ampasctl/ctl-1.4.1.tar.gz;
    sha256 = "16lzgbpxdyhykdwndj1i9vx3h4bfkxqqcrvasvgg70gb5raxj0mj";
  };

  propagatedBuildInputs = (with args; [ilmbase]);
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
