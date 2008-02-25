{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gwt-widgets-0.1.5";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/gwt-widget/gwt-widgets-0.1.5-bin.tar.gz;
    md5 = "daf59b3bc28a9045b6165f185e3e77a0";
  };  
}
