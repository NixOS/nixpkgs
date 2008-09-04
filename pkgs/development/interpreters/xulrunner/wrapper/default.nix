{stdenv, xulrunner, application, launcher}:

stdenv.mkDerivation {
  name = application.name;

  builder = ./builder.sh;
  
  inherit xulrunner launcher;
  
  appfile = application + "/application.ini";

  inherit (application) meta;
}
