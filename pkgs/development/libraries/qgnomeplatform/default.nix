{ mkDerivation, lib, fetchFromGitHub, pkgconfig, gtk3, qtbase, qmake, qtx11extras, pantheon }:

mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "0fb1mzs6sx76bl7f0z2xhc0jq6y1c55jrw1v3na8577is6g5ji0a";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    gtk3
    qtbase
    qtx11extras
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace decoration/decoration.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
    substituteInPlace theme/theme.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "QPlatformTheme for a better Qt application inclusion in GNOME";
    homepage = https://github.com/FedoraQt/QGnomePlatform;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
