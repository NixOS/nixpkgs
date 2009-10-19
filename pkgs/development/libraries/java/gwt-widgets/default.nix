{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gwt-widgets-0.2.0";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = mirror://sourceforge/gwt-widget/gwt-widgets-0.2.0-bin.tar.gz;
    sha256 = "09isj4j6842rj13nv8264irkjjhvmgihmi170ciabc98911bakxb";
  };  
}
