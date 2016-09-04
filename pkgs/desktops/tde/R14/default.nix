{ callPackage, pkgs }:

rec {

  #### Dependencies

  tqt3-thread = callPackage ./dependencies/tqt3 { threadSupport = true; };
  tqt3-nothread = callPackage ./dependencies/tqt3 { threadSupport = false; };
  tqt3 = tqt3-thread;

}
