{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, cmake, qttools,
  deepin-gettext-tools, dtkcore, dtkwidget, deepin
}:

mkDerivation rec {
  pname = "dde-calendar";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "00aqx24jccf88vvkpb9svyjz8knrqyjgd0152psf9dxc9q13f61h";
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

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Calendar for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-calendar;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
