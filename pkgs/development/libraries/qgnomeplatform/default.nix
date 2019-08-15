{ mkDerivation, lib, fetchFromGitHub, pkgconfig, gtk3, qtbase, qmake }:

mkDerivation rec {
  pname = "qgnomeplatform";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "FedoraQt";
    repo = "QGnomePlatform";
    rev = version;
    sha256 = "01ncj21cxd5p7pch6p3zbhv5wp0dgn9vy5hrw54g49fmqnbb1ymz";
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

  meta = with lib; {
    description = "QPlatformTheme for a better Qt application inclusion in GNOME";
    homepage = https://github.com/FedoraQt/QGnomePlatform;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
