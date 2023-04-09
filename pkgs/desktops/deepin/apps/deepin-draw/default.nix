{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, qtbase
, qtsvg
, dtkwidget
, qt5integration
, qt5platform-plugins
}:

stdenv.mkDerivation rec {
  pname = "deepin-draw";
  version = "5.11.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-oryh1b7/78Hp3JclN9vKvfcKRg58nsfGZQvBx6VyJBs";
  };

  patches = [
    (fetchpatch {
      name = "chore: use GNUInstallDirs in CmakeLists";
      url = "https://github.com/linuxdeepin/deepin-draw/commit/dac714fe603e1b77fc39952bfe6949852ee6c2d5.patch";
      sha256 = "sha256-zajxmKkZJT1lcyvPv/PRPMxcstF69PB1tC50gYKDlWA=";
    })
  ];

  postPatch = ''
    substituteInPlace com.deepin.Draw.service \
      --replace "/usr/bin/deepin-draw" "$out/bin/deepin-draw"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qt5integration
    qtsvg
    dtkwidget
    qt5platform-plugins
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  meta = with lib; {
    description = "Lightweight drawing tool for users to freely draw and simply edit images";
    homepage = "https://github.com/linuxdeepin/deepin-draw";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
