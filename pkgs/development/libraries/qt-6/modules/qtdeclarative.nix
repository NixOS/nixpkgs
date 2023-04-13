{ qtModule
, qtbase
, qtlanguageserver
, qtshadertools
, openssl
, python3
}:

qtModule {
  pname = "qtdeclarative";
  qtInputs = [ qtbase qtlanguageserver qtshadertools ];
  propagatedBuildInputs = [ openssl python3 ];
  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/qtdeclarative-default-disable-qmlcache.patch
  ];
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
}
