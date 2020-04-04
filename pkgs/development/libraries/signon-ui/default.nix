{
  stdenv,
  qt5,
  lib,
  fetchFromGitLab,
  libnotify,
  pkgconfig,
  qtbase,
  qmake,
  signond,
  qtwebkit-plugins,
  qtwebkit,
  qtwebengine,
  accounts-qt,
  libproxy,
  gdk-pixbuf
}:


qt5.mkDerivation rec {
  name = "signon-ui";
  version = "0.17.02";

  src = fetchFromGitLab {
    repo = "${name}";
    owner = "accounts-sso";
    rev = "3acb6541";
    sha256 = "1821k48mz99pajv0iv97k80b7g4j8g1xc1xqpqdvb1ijn33yy12g";
  };

  PKG_CONFIG_PATH="${accounts-qt}/lib/pkgconfig";

  preConfigure = ''
    # Do not install tests
    echo 'INSTALLS =' >>tests/unit/tst_inactivity_timer.pro
    echo 'INSTALLS =' >>tests/unit/tst_signon_ui.pro
  '';

  nativeBuildInputs = [
    qmake
    pkgconfig
  ];

  buildInputs = [
    qtbase
    signond
    qtwebkit-plugins
    qtwebkit
    accounts-qt
    qtwebengine
    libnotify
    libproxy
    gdk-pixbuf
  ];

  meta = with stdenv.lib; {
    description = "UI component responsible for handling the user interactions which can happen during the login process of an online account";
    homepage = https://gitlab.com/accounts-sso/signon-ui;
    platforms = platforms.linux;

    license = with licenses; [
      lgpl21
    ];

    maintainers = [ maintainers.konstantsky ];
  };

}
