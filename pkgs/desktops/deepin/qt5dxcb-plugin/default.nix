{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, qtx11extras, libSM,
  mtdev, cairo, deepin, qtbase }:

mkDerivation rec {
  pname = "qt5dxcb-plugin";
  version = "5.0.1";

  srcs = [
    (fetchFromGitHub {
      owner = "linuxdeepin";
      repo = pname;
      rev = version;
      sha256 = "1pkhbx4hzjv7n4mscv7dng9ymjcc1csdc82iy62yxshhq32bcfja";
    })
    qtbase.src
  ];

  sourceRoot = "source";

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    qtx11extras
    libSM
    mtdev
    cairo
    qtbase
  ];

  postPatch = ''
    # The Qt5 platforms plugin is vendored in the package, however what's there is not always up-to-date with what's in nixpkgs.
    # We simply copy the headers from qtbase's source tarball.
    mkdir -p platformplugin/libqt5xcbqpa-dev/${qtbase.version}
    cp -r ../qtbase-everywhere-src-${qtbase.version}/src/plugins/platforms/xcb/*.h platformplugin/libqt5xcbqpa-dev/${qtbase.version}/
  '';

  qmakeFlags = [
    "INSTALL_PATH=${placeholder "out"}/${qtbase.qtPluginPrefix}/platforms"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugin for DDE";
    homepage = https://github.com/linuxdeepin/qt5dxcb-plugin;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
