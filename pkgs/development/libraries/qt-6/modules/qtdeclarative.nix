{ qtModule
, qtbase
, qtshadertools
, openssl
, python3
}:

# TODO? Qt6QmlCompilerPlus

qtModule {
  pname = "qtdeclarative";
  qtInputs = [ qtbase qtshadertools ];
  propagatedBuildInputs = [ openssl openssl.dev python3 ];
  outputs = [ "out" "dev" "bin" ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
  cmakeFlags = [
    "-DQT_FEATURE_quick_designer=ON"
  ];
}
