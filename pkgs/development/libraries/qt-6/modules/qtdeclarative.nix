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
    ../patches/0001-qtdeclarative-disable-qml-disk-cache.patch
    # add version specific QML import path
    ../patches/0002-qtdeclarative-also-use-versioned-qml-paths.patch
  ];
}
