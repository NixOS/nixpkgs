{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
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
  ] ++ lib.optionals (lib.versionAtLeast qtbase.version "5.15") [
    (fetchpatch {
      url = "https://github.com/FedoraQt/QGnomePlatform/commit/c835c9e80cfadd62e01f16591721d2103d28a212.diff";
      sha256 = "Kcj9w+XorfHd47LYDMTINoStvZbu4MjvSumi3TJu/Vw=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
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
    maintainers = teams.gnome.members ++ (with maintainers; [ ]);
    platforms = platforms.linux;
  };
}
