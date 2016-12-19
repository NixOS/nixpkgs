{ stdenv, fetchFromGitHub, cmake, qt5, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qps";
  version = "1.10.16";

  srcs = fetchFromGitHub {
    owner = "QtDesktop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s6hvqfv9hv1cl5pfsmghqn1zqhibr4plq3glzgd8s7swwdnsvjj";
  };

  desktopItem = makeDesktopItem {
    name = "qps";
    exec = "qps";
    icon = "qps";
    comment = "Visual process manager - Qt version of ps/top";
    desktopName = "qps";
    genericName = meta.description;
    categories = "System;";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase qt5.qtx11extras ];

  installPhase = ''
    mkdir -p $out/{bin,share/{man/man1,doc,icons}}
    cp -a src/qps $out/bin/
    cp -a ../README.md $out/share/doc/
    cp -a ../qps.1 $out/share/man/man1/
    cp -a ../icon/icon.xpm $out/share/icons/qps.xpm
    ln -sv "${desktopItem}/share/applications" $out/share/
  '';

  meta = with stdenv.lib; {
    description = "The Qt process manager";
    homepage = https://github.com/QtDesktop/qps;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
