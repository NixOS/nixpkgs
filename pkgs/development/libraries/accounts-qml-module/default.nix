{ stdenv, mkDerivation, fetchFromGitLab, pkgconfig, qmake, accounts-qt, qttools, signond, qtdeclarative, qtbase }:

mkDerivation rec {
  pname = "accounts-qml-module";
  version = "0.7";

  src = fetchFromGitLab {
    sha256 = "0m9zvhx5vkbixxlqy8fszgbkx6cvxa82cfxz23x068ikl33hm941";
    rev = "VERSION_${version}";
    repo = "accounts-qml-module";
    owner = "accounts-sso";
  };

  buildInputs = [ accounts-qt qtdeclarative qttools signond qtbase ];
  nativeBuildInputs = [ pkgconfig qmake ];

  qmakeFlags = [
    "CONFIG+=no_docs"
  ];

  preConfigure = ''
    export QT_PLUGIN_PATH="${qtbase.bin}/${qtbase.qtPluginPrefix}"
    substituteInPlace common-project-config.pri --replace '-Werror' ' '
    substituteInPlace accounts-qml-module.pro --replace 'tests' ' '
  '';

  installPhase = ''
    mkdir -p $out/${qtbase.qtQmlPrefix}
    mv src/Ubuntu  $out/${qtbase.qtQmlPrefix}
  '';


  meta = with stdenv.lib; {
    description = "This QML module provides an API to manage the user's online accounts and get their authentication data.";
    homepage = https://gitlab.com/accounts-sso;
    license = licenses.lgpl21;
    platforms = with platforms; linux;
    maintainers = [ maintainers.konstantsky ];
  };
}
