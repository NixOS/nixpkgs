{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools,
  deepin-gettext-tools, dtkcore, dtkwidget
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-calendar";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1a5zxpz7zncw6mrzv8zmn0j1vk0c8fq0m1xhmnwllffzybrhn4y7";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
    deepin-gettext-tools
  ];

  buildInputs = [
    dtkcore
    dtkwidget
  ];

  postPatch = ''
    patchShebangs .
    sed -i translate_desktop.sh \
      -e "s,/usr/bin/deepin-desktop-ts-convert,deepin-desktop-ts-convert,"
    sed -i com.deepin.Calendar.service \
      -e "s,/usr,$out,"
  '';

  meta = with stdenv.lib; {
    description = "Calendar for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-calendar;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
