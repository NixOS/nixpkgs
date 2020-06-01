{ pkgs, makeScope, libsForQt5 }:
let
  packages = self: with self; {
    setupHook = ./setup-hook.sh;

    # Update script tailored to deepin packages from git repository
    updateScript = { pname, version, src }:
      pkgs.genericUpdater {
        inherit pname version;
        attrPath = "deepin.${pname}";
        versionLister = "${pkgs.common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
        ignoredVersions = "^2014(\\.|rc)|^v[0-9]+";
      };

    dde-api = callPackage ./dde-api { };
    dde-calendar = callPackage ./dde-calendar { };
    dde-control-center = callPackage ./dde-control-center { };
    dde-daemon = callPackage ./dde-daemon { };
    dde-dock = callPackage ./dde-dock { };
    dde-file-manager = callPackage ./dde-file-manager { };
    dde-kwin = callPackage ./dde-kwin { };
    dde-launcher = callPackage ./dde-launcher { };
    dde-network-utils = callPackage ./dde-network-utils { };
    dde-polkit-agent = callPackage ./dde-polkit-agent { };
    dde-qt-dbus-factory = callPackage ./dde-qt-dbus-factory { };
    dde-session-ui = callPackage ./dde-session-ui { };
    deepin-anything = callPackage ./deepin-anything { };
    deepin-calculator = callPackage ./deepin-calculator { };
    deepin-desktop-base = callPackage ./deepin-desktop-base { };
    deepin-desktop-schemas = callPackage ./deepin-desktop-schemas { };
    deepin-editor = callPackage ./deepin-editor { };
    deepin-gettext-tools = callPackage ./deepin-gettext-tools { };
    deepin-gtk-theme = callPackage ./deepin-gtk-theme { };
    deepin-icon-theme = callPackage ./deepin-icon-theme { };
    deepin-image-viewer = callPackage ./deepin-image-viewer { };
    deepin-menu = callPackage ./deepin-menu { };
    deepin-movie-reborn = callPackage ./deepin-movie-reborn { };
    deepin-shortcut-viewer = callPackage ./deepin-shortcut-viewer { };
    deepin-sound-theme = callPackage ./deepin-sound-theme { };
    deepin-terminal = callPackage ./deepin-terminal {
      wnck = pkgs.libwnck3;
    };
    deepin-turbo = callPackage ./deepin-turbo { };
    deepin-wallpapers = callPackage ./deepin-wallpapers { };
    disomaster = callPackage ./disomaster { };
    dpa-ext-gnomekeyring = callPackage ./dpa-ext-gnomekeyring { };
    dtkcore = callPackage ./dtkcore { };
    dtkwidget = callPackage ./dtkwidget { };
    dtkwm = callPackage ./dtkwm { };
    go-dbus-factory = callPackage ./go-dbus-factory { };
    go-gir-generator = callPackage ./go-gir-generator { };
    go-lib = callPackage ./go-lib { };
    qcef = callPackage ./qcef { };
    qt5integration = callPackage ./qt5integration { };
    qt5platform-plugins = callPackage ./qt5platform-plugins { };
    startdde = callPackage ./startdde { };
    udisks2-qt5 = callPackage ./udisks2-qt5 { };

  };

in
makeScope libsForQt5.newScope packages
