{ callPackage, pkgs }:

rec {

  #### Dependencies

  tqt3 = tqt3-thread;
  tqt3-thread = callPackage ./dependencies/tqt3 { threadSupport = true; };
  tqt3-nothread = callPackage ./dependencies/tqt3 { threadSupport = false; };
  tqtinterface = callPackage ./dependencies/tqtinterface { };
  arts = callPackage ./dependencies/arts { };
  dbus-tqt = callPackage ./dependencies/dbus-tqt { };
  dbus-1-tqt = callPackage ./dependencies/dbus-1-tqt { };
  libart-lgpl = callPackage ./dependencies/libart-lgpl { };
}
