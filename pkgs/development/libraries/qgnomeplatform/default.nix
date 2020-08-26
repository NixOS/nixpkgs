{ mkDerivation
, lib
, fetchFromGitHub
, nix-update-script
, pkgconfig
, gtk3
, glib
, qtbase
, qmake
, qtx11extras
, pantheon
, substituteAll
, gsettings-desktop-schemas
}:

mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "1mwqg2zk0sfjq54vz2jjahbgi5sxw8rb71h6mgg459wp99mhlqi0";
  };

  patches = [
    # Hardcode GSettings schema path to avoid crashes from missing schemas
    (substituteAll {
      src = ./hardcode-gsettings.patch;
      gds_gsettings_path = glib.getSchemaPath gsettings-desktop-schemas;
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    glib
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
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "QPlatformTheme for a better Qt application inclusion in GNOME";
    homepage = "https://github.com/FedoraQt/QGnomePlatform";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
