{ lib, fetchFromGitHub, mkDerivation, qmake, qtbase }:

mkDerivation rec {
  pname = "qt-jdenticon";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "qt-jdenticon";
    rev = "v${version}";
    sha256 = "1dk2cmz34pdn79k6lq6jlbvy0gfp0w2vv1w4f8c9xmgmf6brcxq1";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase ];

  dontWrapQtApps = true;

  postPatch = ''
    # Fix plugins dir
    substituteInPlace QtIdenticon.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  meta = with lib; {
    description = "Qt plugin for generating highly recognizable identicons";
    homepage = "https://github.com/Nheko-Reborn/qt-jdenticon";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ unclechu ];
  };
}
