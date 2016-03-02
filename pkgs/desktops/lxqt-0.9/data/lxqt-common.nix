{ stdenv, fetchgit
, cmake
, qt54
, kwindowsystem
, liblxqt
, libqtxdg
, which
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-common";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "e400c79738b7251526d5e5317926f30a70d61801";
    sha256 = "1bcfa6e3301e74471a21e849b42433d0e02c0c43eab2eb5482201ce21cb99389";
  };

  buildInputs = [
    stdenv
    cmake
    qt54.base qt54.tools qt54.x11extras
    kwindowsystem
    liblxqt libqtxdg
    which
  ];

  # - /etc/xdg => $out/etc/xdg
  # - ${LXQT_ETC_XDG_DIR} => $out/etc/xdg
  # - ${LXQT_SHARE_DIR} => $out/share/lxqt
  # - Don't know what to do with the xsession files -- suppressing for now
  # - 'which' => 'command -v'
  patchPhase = ''
    sed -i 's/^INSTALL_/#INSTALL_/' xsession/CMakeLists.txt
	echo "INSTALL_SESSION_FILES(\"$out/share/xsessions\")" >> xsession/CMakeLists.txt
    sed -i 's/if which dbus-launch/if command -v dbus-launch/' startlxqt.in;
  '' + standardPatch;

  # Patch the cmake installer file.
  postConfigure = ''
    sed -i s@/etc/xdg@$out/etc/xdg@g autostart/cmake_install.cmake
  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Common data file required for running an lxde-qt session";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
