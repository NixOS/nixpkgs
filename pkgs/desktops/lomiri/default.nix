{ pkgs, makeScope, libsForQt5
}:

let
  packages = self: with self; {
    cmake-extras = callPackage ./cmake-extras { };
    libqtdbustest = callPackage ./libqtdbustest { };
    unity-api = callPackage ./unity-api { };
    geonames = callPackage ./geonames { };
    dbus-test-runner = callPackage ./dbus-test-runner { };
    qmenumodel = callPackage ./qmenumodel { };
    ubuntu-app-launch = callPackage ./ubuntu-app-launch { };
    ubuntu-ui-toolkit = callPackage ./ubuntu-ui-toolkit { };
    libqtdbusmock = callPackage ./libqtdbusmock { };
    click = callPackage ./click { };
    dbus-cpp = callPackage ./dbus-cpp { };
    trust-store = callPackage ./trust-store { };
    system-settings = callPackage ./system-settings { };
    url-dispatcher = callPackage ./url-dispatcher { };
    libqofono = callPackage ./libqofono { };
    gmenuharness = callPackage ./gmenuharness { };
    indicator-network = callPackage ./indicator-network { };
    deviceinfo = callPackage ./deviceinfo { };
    qdjango = callPackage ./qdjango { };
    libusermetrics = callPackage ./libusermetrics { };
    ubuntu-download-manager = callPackage ./ubuntu-download-manager { };
  };
in makeScope libsForQt5.newScope packages
