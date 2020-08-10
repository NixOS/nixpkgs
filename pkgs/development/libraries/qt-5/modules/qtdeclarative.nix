{ qtModule, lib, fetchpatch, python3, qtbase, qtsvg }:

with lib;

qtModule {
  name = "qtdeclarative";
  qtInputs = [ qtbase qtsvg ];
  nativeBuildInputs = [ python3 ];
  outputs = [ "out" "dev" "bin" ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
  configureFlags = lib.optionals (lib.versionAtLeast qtbase.version "5.11.0") [ "-qml-debug" ];
  devTools = [
    "bin/qml"
    "bin/qmlcachegen"
    "bin/qmleasing"
    "bin/qmlimportscanner"
    "bin/qmllint"
    "bin/qmlmin"
    "bin/qmlplugindump"
    "bin/qmlprofiler"
    "bin/qmlscene"
    "bin/qmltestrunner"
  ];
  patches =
    # https://mail.kde.org/pipermail/kde-distro-packagers/2020-June/000419.html
    lib.optional (lib.versionAtLeast qtbase.version "5.14.2")
      (fetchpatch {
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtdeclarative.git;a=patch;h=3e47ac319b0f53c43cc02a8356c2dec4f0daeef4";
        sha256 = "0wvncg7047q73nm0svc6kb14sigwk7sc53r4778kn033aj0qqszj";
        name = "qtdeclarative-QQuickItemView-fix-max-extent.patch";
      });
}
