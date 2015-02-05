# DO NOT EDIT! This file is generated automatically.
{ }:
{
  baloo = {
    buildInputs = [ "ECM" "KF5" "KF5Auth" "KF5Config" "KF5Crash" "KF5FileMetaData" "KF5I18n" "KF5IdleTime" "KF5KDELibs4Support" "KF5KIO" "KF5Solid" "Qt5" "Xapian" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5CoreAddons" "KF5FileMetaData" "Qt5Core" "Xapian" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  bluedevil = {
    buildInputs = [ "ECM" "KF5" "KF5CoreAddons" "KF5DBusAddons" "KF5I18n" "KF5IconThemes" "KF5KIO" "KF5MODULE" "KF5Notifications" "KF5WidgetsAddons" "LibBlueDevil" "Qt5" "SharedMimeInfo" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [ "SharedMimeInfo" ];
  };

  breeze = {
    buildInputs = [ "ECM" "KDE4" "KDecoration2" "KF5" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5FrameworkIntegration" "KF5I18n" "KF5Service" "KF5WindowSystem" "PkgConfig" "Qt5" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kde-cli-tools = {
    buildInputs = [ "ECM" "KF5" "KF5Config" "KF5I18n" "KF5IconThemes" "KF5KCMUtils" "KF5KDELibs4Support" "KF5Su" "KF5WindowSystem" "Qt5" "Qt5Test" "Qt5X11Extras" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kde-gtk-config = {
    buildInputs = [ "ECM" "GTK2" "GTK3" "KF5" "KF5Archive" "KF5ConfigWidgets" "KF5I18n" "KF5KCMUtils" "KF5NewStuff" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdecoration = {
    buildInputs = [ "ECM" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Gui" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdeplasma-addons = {
    buildInputs = [ "ECM" "GIO" "GLIB2" "GObject" "IBus" "KDE4" "KF5" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5I18n" "KF5KCMUtils" "KF5KDELibs4Support" "KF5KIO" "KF5Kross" "KF5Plasma" "KF5Runner" "KF5Service" "KF5UnitConversion" "KdepimLibs" "Kexiv2" "Lancelot" "Lancelot-Datamodels" "Qt5" "Qt5X11Extras" "SCIM" "SharedMimeInfo" "X11" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [ "SharedMimeInfo" ];
  };

  kfilemetadata = {
    buildInputs = [ "ECM" "EPub" "Exiv2" "FFmpeg" "KF5" "KF5Archive" "KF5I18n" "PopplerQt5" "QMobipocket" "Qt5" "Taglib" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  khelpcenter = {
    buildInputs = [ "ECM" "KF5" "KF5Config" "KF5I18n" "KF5Init" "KF5KCMUtils" "KF5KDELibs4Support" "KF5KHtml" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  khotkeys = {
    buildInputs = [ "ECM" "KF5" "KF5DBusAddons" "KF5GlobalAccel" "KF5I18n" "KF5KCMUtils" "KF5KDELibs4Support" "KF5KIO" "KF5Plasma" "KF5XmlGui" "LibKWorkspace" "Qt5" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kinfocenter = {
    buildInputs = [ "ECM" "EGL" "KF5" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5DBusAddons" "KF5DocTools" "KF5I18n" "KF5IconThemes" "KF5KCMUtils" "KF5KDELibs4Support" "KF5KIO" "KF5Service" "KF5Solid" "KF5Wayland" "KF5WidgetsAddons" "KF5XmlGui" "OpenGL" "OpenGLES" "PCIUTILS" "Qt5" "RAW1394" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kio-extras = {
    buildInputs = [ "ECM" "Exiv2" "JPEG" "KF5" "KF5Archive" "KF5Bookmarks" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5DBusAddons" "KF5DNSSD" "KF5DocTools" "KF5GuiAddons" "KF5I18n" "KF5IconThemes" "KF5KDELibs4Support" "KF5KHtml" "KF5KIO" "KF5Pty" "KF5Solid" "LibSSH" "Mtp" "OpenEXR" "Phonon4Qt5" "Qt5" "Qt5Test" "SLP" "Samba" "SharedMimeInfo" ];
    nativeBuildInputs = [ "MD5SUM_EXECUTABLE" "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [ "SharedMimeInfo" ];
  };

  kmenuedit = {
    buildInputs = [ "ECM" "KF5" "KF5DBusAddons" "KF5I18n" "KF5IconThemes" "KF5KDELibs4Support" "KF5KIO" "KF5Sonnet" "KF5XmlGui" "KHotKeysDBusInterface" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kscreen = {
    buildInputs = [ "ECM" "KF5" "KF5ConfigWidgets" "KF5DBusAddons" "KF5GlobalAccel" "KF5I18n" "KF5Screen" "KF5XmlGui" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  ksshaskpass = {
    buildInputs = [ "ECM" "KF5" "KF5CoreAddons" "KF5DocTools" "KF5I18n" "KF5Wallet" "KF5WidgetsAddons" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  ksysguard = {
    buildInputs = [ "ECM" "KF5" "KF5Config" "KF5CoreAddons" "KF5I18n" "KF5IconThemes" "KF5ItemViews" "KF5KDELibs4Support" "KF5NewStuff" "KF5SysGuard" "Qt5" "Sensors" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kwayland = {
    buildInputs = [ "ECM" "Qt5" "Qt5Concurrent" "Qt5Widgets" "Wayland" "WaylandScanner" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Gui" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kwin = {
    buildInputs = [ "ECM" "EGL" "KDecoration2" "KF5" "KF5Activities" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5Crash" "KF5Declarative" "KF5DocTools" "KF5GlobalAccel" "KF5I18n" "KF5Init" "KF5KCMUtils" "KF5KIO" "KF5NewStuff" "KF5Notifications" "KF5Plasma" "KF5Service" "KF5Wayland" "KF5WidgetsAddons" "KF5WindowSystem" "KF5XmlGui" "Libinput" "Qt5" "Qt5Multimedia" "Qt5Test" "UDev" "Wayland" "X11" "XCB" "XKB" "epoxy" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kwrited = {
    buildInputs = [ "ECM" "KF5" "KF5CoreAddons" "KF5DBusAddons" "KF5I18n" "KF5Notifications" "KF5Pty" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  libbluedevil = {
    buildInputs = [ "Doxygen" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  libkscreen = {
    buildInputs = [ "Doxygen" "ECM" "Qt5" "X11" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  libksysguard = {
    buildInputs = [ "ECM" "KF5" "KF5Auth" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5I18n" "KF5IconThemes" "KF5Plasma" "KF5Service" "KF5WidgetsAddons" "KF5WindowSystem" "Qt5" "Qt5WebKitWidgets" "Qt5X11Extras" "X11" "ZLIB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Config" "KF5I18n" "KF5IconThemes" "Qt5Core" "Qt5Network" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  libmm-qt = {
    buildInputs = [ "ECM" "KF5ModemManagerQt" "ModemManager" "Qt4" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  milou = {
    buildInputs = [ "ECM" "KF5" "KF5Declarative" "KF5I18n" "KF5Plasma" "KF5Runner" "KdepimLibs" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  muon = {
    buildInputs = [ "AkabeiClient" "AppstreamQt" "BODEGA" "DebconfKDE" "ECM" "KF5" "KF5Attica" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5DBusAddons" "KF5Declarative" "KF5I18n" "KF5KDELibs4Support" "KF5NewStuff" "KF5Notifications" "KF5Plasma" "KF5Solid" "KF5Wallet" "KF5WidgetsAddons" "Phonon4Qt5" "QApt" "Qca-qt5" "Qt5" "QtOAuth" "packagekitqt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  oxygen = {
    buildInputs = [ "ECM" "KDE4" "KDE4Workspace" "KF5" "KF5Completion" "KF5Config" "KF5FrameworkIntegration" "KF5GuiAddons" "KF5I18n" "KF5Service" "KF5WidgetsAddons" "KF5WindowSystem" "PkgConfig" "Qt5" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  oxygen-fonts = {
    buildInputs = [ "ECM" ];
    nativeBuildInputs = [ "FONTFORGE_EXECUTABLE" "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  plasma-desktop = {
    buildInputs = [ "Boost" "ECM" "Fontconfig" "Freetype" "GLIB2" "KDE4" "KF5" "KF5Activities" "KF5Attica" "KF5Auth" "KF5Baloo" "KF5DocTools" "KF5Emoticons" "KF5I18n" "KF5ItemModels" "KF5KCMUtils" "KF5KDELibs4Support" "KF5NewStuff" "KF5NotifyConfig" "KF5Plasma" "KF5PlasmaQuick" "KF5Runner" "KF5Wallet" "KRunnerAppDBusInterface" "KSMServerDBusInterface" "KWinDBusInterface" "LibKWorkspace" "LibTaskManager" "OpenGL" "OpenGLES" "PackageKitQt5" "Phonon4Qt5" "PulseAudio" "Qt4" "Qt5" "ScreenSaverDBusInterface" "Strigi" "USB" "X11" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  plasma-nm = {
    buildInputs = [ "ECM" "KF5" "KF5Completion" "KF5ConfigWidgets" "KF5CoreAddons" "KF5DBusAddons" "KF5Declarative" "KF5I18n" "KF5IconThemes" "KF5Init" "KF5ItemViews" "KF5KDELibs4Support" "KF5KIO" "KF5ModemManagerQt" "KF5NetworkManagerQt" "KF5Notifications" "KF5Plasma" "KF5Service" "KF5Solid" "KF5Wallet" "KF5WidgetsAddons" "KF5WindowSystem" "KF5XmlGui" "MobileBroadbandProviderInfo" "ModemManager" "NetworkManager" "OpenConnect" "OpenSSL" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  plasma-workspace = {
    buildInputs = [ "ECM" "KF5" "KF5Activities" "KF5Baloo" "KF5Config" "KF5CoreAddons" "KF5Crash" "KF5DBusAddons" "KF5Declarative" "KF5DocTools" "KF5GlobalAccel" "KF5I18n" "KF5IdleTime" "KF5JsEmbed" "KF5KCMUtils" "KF5KDELibs4Support" "KF5KIO" "KF5NO_MODULE" "KF5NewStuff" "KF5NotifyConfig" "KF5Plasma" "KF5PlasmaQuick" "KF5Runner" "KF5Screen" "KF5Solid" "KF5Su" "KF5SysGuard" "KF5TextEditor" "KF5TextWidgets" "KF5Wallet" "KF5Wayland" "KF5WebKit" "KWinDBusInterface" "Phonon4Qt5" "Prison" "Qalculate" "Qt5" "Qt5DBus" "Qt5Qml" "Qt5Quick" "Qt5Script" "Qt5Test" "Qt5WebKitWidgets" "Wayland" "WaylandScanner" "X11" "XCB" "ZLIB" "dbusmenu-qt5" "libgps" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5KIO" "KF5SysGuard" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  plasma-workspace-wallpapers = {
    buildInputs = [ "ECM" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  polkit-kde-agent = {
    buildInputs = [ "ECM" "KF5" "KF5Config" "KF5CoreAddons" "KF5Crash" "KF5DBusAddons" "KF5I18n" "KF5IconThemes" "KF5Notifications" "KF5WidgetsAddons" "KF5WindowSystem" "PolkitQt5-1" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  powerdevil = {
    buildInputs = [ "ECM" "KF5" "KF5Auth" "KF5Config" "KF5GlobalAccel" "KF5I18n" "KF5IdleTime" "KF5KDELibs4Support" "KF5KIO" "KF5NotifyConfig" "KF5Solid" "LibKWorkspace" "Qt5" "ScreenSaverDBusInterface" "UDev" "X11" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  sddm-kcm = {
    buildInputs = [ "ECM" "KF5" "KF5Auth" "KF5ConfigWidgets" "KF5CoreAddons" "KF5I18n" "KF5KIO" "KF5XmlGui" "Qt5" "X11" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  systemsettings = {
    buildInputs = [ "ECM" "KF5" "KF5Config" "KF5DBusAddons" "KF5DocTools" "KF5I18n" "KF5IconThemes" "KF5ItemViews" "KF5KCMUtils" "KF5KHtml" "KF5KIO" "KF5Service" "KF5WindowSystem" "KF5XmlGui" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

}
