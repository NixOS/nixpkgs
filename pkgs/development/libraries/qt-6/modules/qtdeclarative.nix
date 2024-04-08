{ qtModule
, qtbase
, qtlanguageserver
, qtshadertools
, openssl
, python3
}:

qtModule {
  pname = "qtdeclarative";
  propagatedBuildInputs = [ qtbase qtlanguageserver qtshadertools openssl python3 ];
  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/qtdeclarative-default-disable-qmlcache.patch
    # add version specific QML import path
    ../patches/qtdeclarative-qml-paths.patch
  ];
}
