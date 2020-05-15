{ stdenv
, mkDerivation
, fetchFromGitHub
, pkgconfig
, cmake
, qttools
, deepin-gettext-tools
, dtkcore
, dtkwidget
, deepin
}:

mkDerivation rec {
  pname = "dde-calendar";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1zzr3crkz4l5l135y0m53vqhv7fkrbvbspk8295swz9gsm3f7ah9";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    deepin-gettext-tools
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkwidget
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs translate_generation.sh
    patchShebangs translate_desktop.sh

    fixPath $out /usr com.deepin.Calendar.service

    sed -i translate_desktop.sh \
      -e "s,/usr/bin/deepin-desktop-ts-convert,deepin-desktop-ts-convert,"
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Calendar for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-calendar";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
