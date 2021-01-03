{ pkgs, makeScope, libsForQt5
}:

let
  packages = self: with self; {
    cmake-extras = callPackage ./cmake-extras { };
    libqtdbustest = callPackage ./libqtdbustest { };
    unity-api = callPackage ./unity-api { };
    geonames = callPackage ./geonames { };
    dbus-test-runner = callPackage ./dbus-test-runner{ };
    qmenumodel = callPackage ./qmenumodel { };
    ubuntu-app-launch = callPackage ./ubuntu-app-launch { };
    ubuntu-ui-toolkit = callPackage ./ubuntu-ui-toolkit { };
    libqtdbusmock = callPackage ./libqtdbusmock { };
    dbus-cpp = callPackage ./dbus-cpp { };
    trust-store = callPackage ./trust-store{ };
  };
in makeScope libsForQt5.newScope packages
