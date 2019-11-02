{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qtbase, udisks2-qt5, utillinux,
  dtkcore, deepin }:

mkDerivation rec {
  pname = "deepin-anything";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1kvyffrii4b012f6ld1ih14qrn7gg5cxbdpbkac0wxb22hnz0azm";
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
    "PREFIX=${placeholder "out"}"
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

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin file search tool";
    homepage = https://github.com/linuxdeepin/deepin-anything;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
