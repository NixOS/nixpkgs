{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gwt-dragdrop-1.2.6";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://gwt-dnd.googlecode.com/files/gwt-dragdrop-1.2.6.jar;
    sha1 = "97bbbd3e8fb3f8feaa4cfab99b371aa3abec5896";
  };  
}
