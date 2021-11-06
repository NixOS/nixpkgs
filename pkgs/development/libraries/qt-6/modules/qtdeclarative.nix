{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
, qtshadertools
, openssl
, python3
}:

qtModule {
  pname = "qtdeclarative";
  qtInputs = [ qtbase qtshadertools ];
  buildInputs = [ openssl openssl.dev python3 libglvnd libxkbcommon vulkan-headers ];
  outputs = [ "out" "dev" "bin" ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QML2_IMPORT_PREFIX=\"$qtQmlPrefix\""
  '';
  configureFlags = [ "-qml-debug" ];
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

  # debug: install is failing
  splitBuildInstall = {
    # needed to disable rebuild
    # TODO simpler way? cmake hooks trigger rebuild?
    installPhase = ''
      cmake -P cmake_install.cmake
    '';
  };
}
