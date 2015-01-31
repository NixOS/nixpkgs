# DO NOT EDIT! This file is generated automatically.
{ }:
{
  attica = {
    buildInputs = [ "ECM" "Qt5" "Qt5Widgets" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  extra-cmake-modules = {
    buildInputs = [ "AGG" "Blitz" "BlueZ" "ENCHANT" "Eigen2" "FFmpeg" "Flac" "Flex" "GObject" "GStreamer" "LCMS" "LibArt" "OpenEXR" "PCRE" "QCA2" "QImageBlitz" "Qt5Core" "Qt5LinguistTools" "Sqlite" "Strigi" "USB" "Xine" "Xmms" ];
    nativeBuildInputs = [ "LibXslt" "QCOLLECTIONGENERATOR_EXECUTABLE" "SPHINX_EXECUTABLE" "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  frameworkintegration = {
    buildInputs = [ "ECM" "KF5Config" "KF5ConfigWidgets" "KF5I18n" "KF5IconThemes" "KF5KIO" "KF5Notifications" "KF5WidgetsAddons" "OxygenFont" "Qt5" "Qt5Test" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5ConfigWidgets" "KF5IconThemes" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kactivities = {
    buildInputs = [ "Boost" "ECM" "KF5" "KF5Config" "KF5CoreAddons" "KF5DBusAddons" "KF5Declarative" "KF5GlobalAccel" "KF5I18n" "KF5KCMUtils" "KF5KIO" "KF5Service" "KF5WindowSystem" "KF5XmlGui" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kapidox = {
    buildInputs = [  ];
    nativeBuildInputs = [ "PythonInterp" "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  karchive = {
    buildInputs = [ "BZip2" "ECM" "KF5Archive" "LibLZMA" "Qt5Core" "Qt5Test" "ZLIB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kauth = {
    buildInputs = [ "ECM" "KF5CoreAddons" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5CoreAddons" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kbookmarks = {
    buildInputs = [ "ECM" "KF5ConfigWidgets" "KF5CoreAddons" "KF5IconThemes" "KF5WidgetsAddons" "KF5XmlGui" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5ConfigWidgets" "KF5IconThemes" "KF5XmlGui" "Qt5Widgets" "Qt5Xml" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kcmutils = {
    buildInputs = [ "ECM" "KF5ConfigWidgets" "KF5CoreAddons" "KF5I18n" "KF5IconThemes" "KF5ItemViews" "KF5Service" "KF5XmlGui" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5ConfigWidgets" "KF5IconThemes" "KF5ItemViews" "KF5Service" "KF5XmlGui" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kcodecs = {
    buildInputs = [ "ECM" "Qt5Core" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kcompletion = {
    buildInputs = [ "ECM" "KF5Config" "KF5WidgetsAddons" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Config" "KF5WidgetsAddons" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kconfig = {
    buildInputs = [ "ECM" "Qt5" "Qt5Concurrent" "Qt5Core" "Qt5Gui" "Qt5Test" "Qt5Xml" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Xml" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kconfigwidgets = {
    buildInputs = [ "ECM" "KF5Auth" "KF5Codecs" "KF5Config" "KF5CoreAddons" "KF5DocTools" "KF5GuiAddons" "KF5I18n" "KF5WidgetsAddons" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Auth" "KF5Codecs" "KF5Config" "KF5GuiAddons" "KF5I18n" "KF5WidgetsAddons" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kcoreaddons = {
    buildInputs = [ "ECM" "FAM" "Qt5" "Qt5Test" "Qt5Widgets" "SharedMimeInfo" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [ "SharedMimeInfo" ];
  };

  kcrash = {
    buildInputs = [ "ECM" "KF5CoreAddons" "KF5WindowSystem" "Qt5" "Qt5Test" "Qt5Widgets" "Qt5X11Extras" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5CoreAddons" "KF5WindowSystem" "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdbusaddons = {
    buildInputs = [ "ECM" "Qt5DBus" "Qt5Test" "Qt5X11Extras" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5DBus" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdeclarative = {
    buildInputs = [ "ECM" "KF5" "KF5Config" "KF5GlobalAccel" "KF5GuiAddons" "KF5I18n" "KF5IconThemes" "KF5KIO" "KF5WidgetsAddons" "KF5WindowSystem" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5KIO" "Qt5Qml" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kded = {
    buildInputs = [ "ECM" "KF5Config" "KF5CoreAddons" "KF5Crash" "KF5DBusAddons" "KF5DocTools" "KF5Init" "KF5Service" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdelibs4support = {
    buildInputs = [ "AGG" "Blitz" "BlueZ" "DocBookXML4" "ECM" "ENCHANT" "Eigen2" "FFmpeg" "Flac" "GObject" "GStreamer" "KDEWin" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5Crash" "KF5DesignerPlugin" "KF5DocTools" "KF5GlobalAccel" "KF5GuiAddons" "KF5I18n" "KF5IconThemes" "KF5KIO" "KF5Notifications" "KF5Parts" "KF5Service" "KF5TextWidgets" "KF5UnitConversion" "KF5WidgetsAddons" "KF5WindowSystem" "KF5XmlGui" "LCMS" "LibArt" "NetworkManager" "OpenEXR" "OpenSSL" "PCRE" "QCA2" "QImageBlitz" "QNtrack" "Qt5" "Qt5X11Extras" "Sqlite" "USB" "X11" "Xine" "Xmms" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KDEWin" "KF5Auth" "KF5ConfigWidgets" "KF5CoreAddons" "KF5Crash" "KF5DesignerPlugin" "KF5DocTools" "KF5Emoticons" "KF5GuiAddons" "KF5IconThemes" "KF5Init" "KF5ItemModels" "KF5KDELibs4Support" "KF5Notifications" "KF5Parts" "KF5TextWidgets" "KF5UnitConversion" "KF5WindowSystem" "Qt5DBus" "Qt5PrintSupport" "Qt5Xml" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdesignerplugin = {
    buildInputs = [ "ECM" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5DocTools" "KF5IconThemes" "KF5ItemViews" "KF5KIO" "KF5Plotting" "KF5Sonnet" "KF5TextWidgets" "KF5WebKit" "KF5WidgetsAddons" "KF5XmlGui" "Qt5Core" "Qt5Designer" "Qt5Test" "Qt5Widgets" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdesu = {
    buildInputs = [ "ECM" "KF5CoreAddons" "KF5Pty" "KF5Service" "Qt5Core" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Pty" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdewebkit = {
    buildInputs = [ "ECM" "KF5Config" "KF5CoreAddons" "KF5JobWidgets" "KF5KIO" "KF5Parts" "KF5Service" "KF5Wallet" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5WebKitWidgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdnssd = {
    buildInputs = [ "Avahi" "DNSSD" "ECM" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Network" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kdoctools = {
    buildInputs = [ "DocBookXML4" "DocBookXSL" "ECM" "KF5Archive" "KF5DocTools" "KF5I18n" "LibXml2" "Qt5Core" ];
    nativeBuildInputs = [ "LibXslt" "cmake" ];
    propagatedBuildInputs = [ "KF5Archive" "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kemoticons = {
    buildInputs = [ "ECM" "KF5Archive" "KF5Config" "KF5CoreAddons" "KF5Service" "Qt5" "Qt5Test" "Qt5Xml" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Archive" "KF5Service" "Qt5Gui" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kglobalaccel = {
    buildInputs = [ "ECM" "Qt5" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5DBus" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kguiaddons = {
    buildInputs = [ "ECM" "Qt5" "Qt5Gui" "Qt5X11Extras" "X11" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Gui" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  khtml = {
    buildInputs = [ "ECM" "GIF" "JPEG" "KDEWin" "KF5Archive" "KF5Codecs" "KF5GlobalAccel" "KF5I18n" "KF5IconThemes" "KF5JS" "KF5KIO" "KF5Notifications" "KF5Parts" "KF5Sonnet" "KF5TextWidgets" "KF5Wallet" "KF5WidgetsAddons" "KF5WindowSystem" "KF5XmlGui" "OpenSSL" "PNG" "Phonon4Qt5" "Qt5" "Qt5Test" "Qt5X11Extras" "X11" ];
    nativeBuildInputs = [ "Perl" "cmake" ];
    propagatedBuildInputs = [ "KF5Archive" "KF5Bookmarks" "KF5GlobalAccel" "KF5I18n" "KF5IconThemes" "KF5JS" "KF5KIO" "KF5Notifications" "KF5Parts" "KF5Sonnet" "KF5Wallet" "KF5WidgetsAddons" "KF5WindowSystem" "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  ki18n = {
    buildInputs = [ "ECM" "LibIntl" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kiconthemes = {
    buildInputs = [ "ECM" "KF5ConfigWidgets" "KF5I18n" "KF5ItemViews" "KF5WidgetsAddons" "Qt5" "Qt5DBus" "Qt5Svg" "Qt5Widgets" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5ConfigWidgets" "KF5I18n" "KF5ItemViews" "KF5WidgetsAddons" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kidletime = {
    buildInputs = [ "ECM" "Qt5" "X11" "X11_XCB" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kimageformats = {
    buildInputs = [ "ECM" "Jasper" "OpenEXR" "Qt5Gui" "Qt5PrintSupport" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kinit = {
    buildInputs = [ "ECM" "KF5Config" "KF5Crash" "KF5DocTools" "KF5I18n" "KF5KIO" "KF5Service" "KF5WindowSystem" "Libcap" "Qt5" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kio = {
    buildInputs = [ "ACL" "ECM" "GSSAPI" "KF5Archive" "KF5Bookmarks" "KF5Codecs" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5DBusAddons" "KF5DocTools" "KF5I18n" "KF5IconThemes" "KF5ItemViews" "KF5JobWidgets" "KF5Notifications" "KF5Service" "KF5Solid" "KF5Wallet" "KF5WidgetsAddons" "KF5WindowSystem" "KF5XmlGui" "LibXml2" "OpenSSL" "Qt5" "Qt5Concurrent" "Qt5Core" "Qt5Script" "Qt5Test" "Qt5Widgets" "Strigi" "X11" "ZLIB" ];
    nativeBuildInputs = [ "LibXslt" "cmake" ];
    propagatedBuildInputs = [ "KF5Bookmarks" "KF5Completion" "KF5ItemViews" "KF5JobWidgets" "KF5Service" "KF5Solid" "KF5XmlGui" "Qt5Network" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kitemmodels = {
    buildInputs = [ "ECM" "Grantlee" "Qt5" "Qt5Core" "Qt5Script" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kitemviews = {
    buildInputs = [ "ECM" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kjobwidgets = {
    buildInputs = [ "ECM" "KF5CoreAddons" "KF5WidgetsAddons" "Qt5" "Qt5X11Extras" "X11" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5CoreAddons" "KF5WidgetsAddons" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kjs = {
    buildInputs = [ "ECM" "PCRE" "Qt5Core" "Qt5Test" ];
    nativeBuildInputs = [ "Perl" "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kjsembed = {
    buildInputs = [ "ECM" "KF5DocTools" "KF5I18n" "KF5JS" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5I18n" "KF5JS" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kmediaplayer = {
    buildInputs = [ "ECM" "KF5Parts" "KF5XmlGui" "Qt5DBus" "Qt5Test" "Qt5Widgets" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Parts" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  knewstuff = {
    buildInputs = [ "ECM" "KF5Archive" "KF5Attica" "KF5Completion" "KF5Config" "KF5CoreAddons" "KF5I18n" "KF5IconThemes" "KF5ItemViews" "KF5KIO" "KF5TextWidgets" "KF5WidgetsAddons" "KF5XmlGui" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Archive" "KF5Attica" "KF5KIO" "KF5XmlGui" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  knotifications = {
    buildInputs = [ "ECM" "KF5Codecs" "KF5Config" "KF5CoreAddons" "KF5IconThemes" "KF5Service" "KF5WindowSystem" "Phonon4Qt5" "Qt5" "Qt5X11Extras" "X11" "dbusmenu-qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5WindowSystem" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  knotifyconfig = {
    buildInputs = [ "ECM" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5I18n" "KF5KIO" "KF5Notifications" "KF5Service" "KF5WidgetsAddons" "KF5XmlGui" "Phonon4Qt5" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5I18n" "KF5KIO" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kpackage = {
    buildInputs = [ "ECM" "KF5Archive" "KF5Config" "KF5CoreAddons" "KF5DocTools" "KF5I18n" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kparts = {
    buildInputs = [ "ECM" "KF5Config" "KF5CoreAddons" "KF5I18n" "KF5IconThemes" "KF5JobWidgets" "KF5KIO" "KF5Notifications" "KF5Service" "KF5TextWidgets" "KF5WidgetsAddons" "KF5XmlGui" "Qt5" "Qt5Test" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5KIO" "KF5Notifications" "KF5TextWidgets" "KF5XmlGui" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kplotting = {
    buildInputs = [ "ECM" "Qt5" "Qt5Widgets" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kpty = {
    buildInputs = [ "ECM" "KF5CoreAddons" "KF5I18n" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5CoreAddons" "KF5I18n" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kross = {
    buildInputs = [ "ECM" "KF5Completion" "KF5CoreAddons" "KF5DocTools" "KF5I18n" "KF5IconThemes" "KF5KIO" "KF5Parts" "KF5Service" "KF5WidgetsAddons" "KF5XmlGui" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5I18n" "KF5IconThemes" "KF5KIO" "KF5Parts" "KF5WidgetsAddons" "Qt5Script" "Qt5Widgets" "Qt5Xml" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  krunner = {
    buildInputs = [ "ECM" "KF5Config" "KF5CoreAddons" "KF5I18n" "KF5KIO" "KF5Plasma" "KF5Service" "KF5Solid" "KF5ThreadWeaver" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Plasma" "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kservice = {
    buildInputs = [ "ECM" "KF5Config" "KF5CoreAddons" "KF5Crash" "KF5DBusAddons" "KF5DocTools" "KF5I18n" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Config" "KF5CoreAddons" "KF5DBusAddons" "KF5I18n" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  ktexteditor = {
    buildInputs = [ "ECM" "KF5Archive" "KF5Config" "KF5GuiAddons" "KF5I18n" "KF5KIO" "KF5Parts" "KF5Sonnet" "LibGit2" "Qt5" ];
    nativeBuildInputs = [ "Perl" "cmake" ];
    propagatedBuildInputs = [  ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  ktextwidgets = {
    buildInputs = [ "ECM" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5I18n" "KF5IconThemes" "KF5Service" "KF5Sonnet" "KF5WidgetsAddons" "KF5WindowSystem" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Completion" "KF5ConfigWidgets" "KF5I18n" "KF5IconThemes" "KF5Service" "KF5Sonnet" "KF5WindowSystem" "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kunitconversion = {
    buildInputs = [ "ECM" "KF5I18n" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Config" "KF5I18n" "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kwallet = {
    buildInputs = [ "ECM" "Gpgme" "KF5Config" "KF5CoreAddons" "KF5DBusAddons" "KF5Gpgmepp" "KF5I18n" "KF5IconThemes" "KF5Notifications" "KF5Service" "KF5WidgetsAddons" "KF5WindowSystem" "LibGcrypt" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Config" "KF5WindowSystem" "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kwidgetsaddons = {
    buildInputs = [ "ECM" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kwindowsystem = {
    buildInputs = [ "ECM" "Qt5" "Qt5WinExtras" "X11" "XCB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Widgets" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  kxmlgui = {
    buildInputs = [ "ECM" "KF5Attica" "KF5Config" "KF5ConfigWidgets" "KF5GlobalAccel" "KF5I18n" "KF5IconThemes" "KF5ItemViews" "KF5TextWidgets" "KF5WidgetsAddons" "KF5WindowSystem" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "KF5Attica" "KF5Config" "KF5ConfigWidgets" "KF5GlobalAccel" "KF5IconThemes" "KF5ItemViews" "KF5TextWidgets" "KF5WindowSystem" "Qt5DBus" "Qt5Xml" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  networkmanager-qt = {
    buildInputs = [ "ECM" "KF5NetworkManagerQt" "NetworkManager" "Qt4" "Qt5" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  plasma-framework = {
    buildInputs = [ "ECM" "EGL" "Gpgme" "KActivities" "KCoreAddons" "KDE4Support" "KDESu" "KDeclarative" "KF5" "KF5Activities" "KF5Archive" "KF5Auth" "KF5Bookmarks" "KF5Codecs" "KF5Completion" "KF5Config" "KF5ConfigWidgets" "KF5CoreAddons" "KF5Crash" "KF5DBusAddons" "KF5Declarative" "KF5DocTools" "KF5GlobalAccel" "KF5GuiAddons" "KF5I18n" "KF5IconThemes" "KF5IdleTime" "KF5Init" "KF5ItemModels" "KF5ItemViews" "KF5JS" "KF5JobWidgets" "KF5KArchive" "KF5KAuth" "KF5KBookmarks" "KF5KCodecs" "KF5KCompletion" "KF5KConfig" "KF5KConfigWidgets" "KF5KCoreAddons" "KF5KCrash" "KF5KDBusAddons" "KF5KDE4Support" "KF5KDESu" "KF5KDeclarative" "KF5KDocTools" "KF5KF5GlobalAccel" "KF5KGuiAddons" "KF5KI18n" "KF5KIO" "KF5KIconThemes" "KF5KIdleTime" "KF5KInit" "KF5KJS" "KF5KJobWidgets" "KF5KNotifications" "KF5KParts" "KF5KService" "KF5KTextWidgets" "KF5KUnitConversion" "KF5KWallet" "KF5KWidgetsAddons" "KF5KWindowSystem" "KF5Kross" "KF5NO_MODULE" "KF5Notifications" "KF5Package" "KF5Parts" "KF5Service" "KF5Solid" "KF5Sonnet" "KF5Su" "KF5TextWidgets" "KF5ThreadWeaver" "KF5UnitConversion" "KF5Wallet" "KF5WidgetsAddons" "KF5WindowSystem" "KF5XmlGui" "KdepimLibs" "OpenGL" "QCA2" "Qt5" "Qt5Test" "Qt5Widgets" "Solid" "X11" "XCB" ];
    nativeBuildInputs = [ "SH" "cmake" ];
    propagatedBuildInputs = [ "KF5Package" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  solid = {
    buildInputs = [ "ECM" "IOKit" "MediaPlayerInfo" "Qt5" "Qt5Qml" "UDev" ];
    nativeBuildInputs = [ "BISON" "FLEX" "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  sonnet = {
    buildInputs = [ "ASPELL" "ECM" "ENCHANT" "HSPELL" "HUNSPELL" "Qt5" "Qt5Test" "ZLIB" ];
    nativeBuildInputs = [ "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

  threadweaver = {
    buildInputs = [ "ECM" "KF5ThreadWeaver" "Qt5" "Qt5Core" "Qt5Test" "Qt5Widgets" ];
    nativeBuildInputs = [ "SNIPPETEXTRACTOR" "cmake" ];
    propagatedBuildInputs = [ "Qt5Core" ];
    propagatedNativeBuildInputs = [  ];
    propagatedUserEnvPkgs = [  ];
  };

}
