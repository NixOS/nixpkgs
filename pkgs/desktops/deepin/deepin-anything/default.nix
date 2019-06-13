{ stdenv, fetchFromGitHub, pkgconfig, qtbase, udisks2-qt5, utillinux,
  dtkcore, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-anything";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1qggqjjqz2y51pag0v5qniv6763mgrmzjmr7248xx2paw3a923vk";
  };

  outputs = [ "out" "modsrc" ];

  nativeBuildInputs = [
    pkgconfig
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    qtbase
    udisks2-qt5
    utillinux
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "DEB_HOST_MULTIARCH="
    "PREFIX=${placeholder ''out''}"
  ];

  postPatch = ''
    searchHardCodedPaths  # for debugging
    fixPath $modsrc /usr/src Makefile
    fixPath $out /usr Makefile
    fixPath $out /usr server/tool/tool.pro
    fixPath $out /etc server/tool/tool.pro
    fixPath $out /usr/bin \
      server/tool/deepin-anything-tool.service \
      server/tool/com.deepin.anything.service \
      server/monitor/deepin-anything-monitor.service
    sed -e 's,/lib/systemd,$$PREFIX/lib/systemd,' -i server/monitor/src/src.pro server/tool/tool.pro
  '';

  postFixup = ''
    searchHardCodedPaths $out  # for debugging
    searchHardCodedPaths $modsrc  # for debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin file search tool";
    homepage = https://github.com/linuxdeepin/deepin-anything;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
