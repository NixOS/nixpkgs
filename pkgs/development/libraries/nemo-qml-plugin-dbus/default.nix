{ mkDerivation, lib, fetchFromGitLab, qmake, qtbase }:

mkDerivation rec {
  pname = "nemo-qml-plugin-dbus";
  version = "2.1.23";

  src = fetchFromGitLab {
    domain = "git.sailfishos.org";
    owner = "mer-core";
    repo = "nemo-qml-plugin-dbus";
    rev = version;
    sha256 = "0ww478ds7a6h4naa7vslj6ckn9cpsgcml0q7qardkzmdmxsrv1ag";
  };

  nativeBuildInputs = [ qmake ];

  postPatch = ''
    substituteInPlace dbus.pro --replace ' tests' ""
    substituteInPlace src/nemo-dbus/nemo-dbus.pro \
      --replace /usr $out \
      --replace '$$[QT_INSTALL_LIBS]' $out'/lib'
    substituteInPlace src/plugin/plugin.pro \
      --replace '$$[QT_INSTALL_QML]' $out'/${qtbase.qtQmlPrefix}'
  '';

  meta = with lib; {
    description = "Nemo DBus plugin for qml";
    homepage = "https://git.sailfishos.org/mer-core/nemo-qml-plugin-dbus/";
    license = licenses.lgpl2Only;
    maintainers = [ maintainers.Thra11 ];
    platforms = platforms.linux;
  };
}
