/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "pcall";
  version = "0.3";

  parasites = [ "pcall-tests" ];

  description = "System lacks description";

  deps = [ args."alexandria" args."bordeaux-threads" args."fiveam" args."pcall-queue" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/pcall/2010-10-06/pcall-0.3.tgz";
    sha256 = "02idx1wnv9770fl2nh179sb8njw801g70b5mf8jqhqm2gwsb731y";
  };

  packageName = "pcall";

  asdFilesToKeep = ["pcall.asd"];
  overrides = x: x;
}
/* (SYSTEM pcall DESCRIPTION System lacks description SHA256
    02idx1wnv9770fl2nh179sb8njw801g70b5mf8jqhqm2gwsb731y URL
    http://beta.quicklisp.org/archive/pcall/2010-10-06/pcall-0.3.tgz MD5
    019d85dfd1d5d0ee8d4ee475411caf6b NAME pcall FILENAME pcall DEPS
    ((NAME alexandria FILENAME alexandria)
     (NAME bordeaux-threads FILENAME bordeaux-threads)
     (NAME fiveam FILENAME fiveam) (NAME pcall-queue FILENAME pcall-queue))
    DEPENDENCIES (alexandria bordeaux-threads fiveam pcall-queue) VERSION 0.3
    SIBLINGS (pcall-queue) PARASITES (pcall-tests)) */
