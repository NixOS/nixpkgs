{ stdenv, fetchFromGitHub, qtbase, python, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-anything";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0b3mz9hk1nv4kbjaknwcjajksvm55f0nb6zx2iwv3a61yf4yw6wv";
  };

  nativeBuildInputs = [
    python
    deepin.setupHook
  ];

  buildInputs = [
    qtbase
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs .
    sed -i -e 's,PREFIX=/usr,PREFIX=$(PREFIX),' -e 's,LIB_INSTALL_DIR=/usr,LIB_INSTALL_DIR=$(PREFIX),' Makefile
    sed -i -e 's,/lib/systemd,$$PREFIX/lib/systemd,' server/src/src.pro
    fixPath $out /usr/bin/deepin-anything-server server/deepin-anything-server.service

    sed -i -e 's,$(DESTDIR)/usr,$(PREFIX),' Makefile
  '';

  makeFlags = [ "DEB_HOST_MULTIARCH=" "PREFIX=$(out)" ];

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin Anything file search tool";
    homepage = https://github.com/linuxdeepin/deepin-anything;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
