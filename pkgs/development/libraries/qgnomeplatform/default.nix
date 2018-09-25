{ stdenv, fetchFromGitHub, pkgconfig, gtk3, qtbase, qmake }:

stdenv.mkDerivation rec {
  name = "qgnomeplatform-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "1403300d435g7ngcxsgnllhryk63nrhl1ahx16b28wkxnh2vi9ly";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    gtk3
    qtbase
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace qgnomeplatform.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  meta = with stdenv.lib; {
    description = "QPlatformTheme for a better Qt application inclusion in GNOME";
    homepage = https://github.com/FedoraQt/QGnomePlatform;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
