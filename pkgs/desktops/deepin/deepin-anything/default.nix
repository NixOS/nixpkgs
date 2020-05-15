{ stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
, pkgconfig
, qtbase
, udisks2-qt5
, utillinux
, dtkcore
, deepin
}:

mkDerivation rec {
  pname = "deepin-anything";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1kvyffrii4b012f6ld1ih14qrn7gg5cxbdpbkac0wxb22hnz0azm";
  };

  patches = [
    # fix compilation error and add support to kernel 5.6
    # https://github.com/linuxdeepin/deepin-anything/pull/27
    (fetchpatch {
      name = "linux-5.6.patch";
      url = "https://github.com/linuxdeepin/deepin-anything/commit/764b820c2bcd7248993349b32f91043fc58ee958.patch";
      sha256 = "1ww4xllxc2s04px6fy8wp5cyw54xaz155ry30sqz21vl8awfr36h";
    })
  ];

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

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin file search tool";
    homepage = "https://github.com/linuxdeepin/deepin-anything";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
