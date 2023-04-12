{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, dtkwidget
, deepin-gettext-tools
, qt5integration
, qmake
, qtbase
, qttools
, qtx11extras
, pkg-config
, wrapQtAppsHook
, udisks2-qt5
}:

stdenv.mkDerivation rec {
  pname = "dde-device-formatter";
  version = "unstable-2022-09-05";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "9b8489cb2bb7c85bd62557d16a5eabc94100512e";
    sha256 = "sha256-Mi48dSDCoKhr8CGt9z64/9d7+r9QSrPPICv+R5VDuaU=";
  };

  patches = [
    (fetchpatch {
      name = "chore-do-not-use-hardcode-path.patch";
      url = "https://github.com/linuxdeepin/dde-device-formatter/commit/b836a498b8e783e0dff3820302957f15ee8416eb.patch";
      sha256 = "sha256-i/VqJ6EmCyhE6weHKUB66bW6b51gLyssIAzb5li4aJM=";
    })
  ];

  postPatch = ''
    substituteInPlace dde-device-formatter.pro --replace "/usr" "$out"
    patchShebangs *.sh
  '';

  nativeBuildInputs = [
    qmake
    qttools
    pkg-config
    wrapQtAppsHook
    deepin-gettext-tools
  ];

  buildInputs = [
    dtkwidget
    udisks2-qt5
    qtx11extras
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  meta = with lib; {
    description = "A simple graphical interface for creating file system in a block device";
    homepage = "https://github.com/linuxdeepin/dde-device-formatter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
