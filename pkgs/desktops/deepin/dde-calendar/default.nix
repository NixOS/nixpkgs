{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools,
  deepin-gettext-tools, dtkcore, dtkwidget, deepin
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-calendar";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0k973rv0prvr7cg1xwg7kr14fkx13aslhiqc3q7vpakfk53qsw4n";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Calendar for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-calendar;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
