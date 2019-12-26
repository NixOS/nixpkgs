{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, cmake, deepin,
  dtkcore, dtkwidget, kcodecs, qttools, syntax-highlighting,
  wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-editor";
  version = "1.2.9.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0g7c3adqwn8i4ndxdrzibahr75dddz1fiqnsh3bjj1jjr86rv4ks";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    wrapQtAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    kcodecs
    syntax-highlighting
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    patchShebangs translate_generation.sh

    fixPath $out /usr \
      CMakeLists.txt \
      dedit/main.cpp \
      src/resources/settings.json \
      src/thememodule/themelistmodel.cpp

    substituteInPlace deepin-editor.desktop \
      --replace "Exec=deepin-editor" "Exec=$out/bin/deepin-editor"

    substituteInPlace src/editwrapper.cpp \
      --replace "appExec = \"deepin-editor\"" "appExec = \"$out/bin/deepin-editor\""
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Simple editor for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-editor;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo worldofpeace ];
  };
}
