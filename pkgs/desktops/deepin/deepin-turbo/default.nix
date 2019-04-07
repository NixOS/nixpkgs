{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-turbo";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "13vbj18pclv7c25pb1y5x6dd7wmcgisa40mb13qyixnzpq2ssjg5";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    deepin.setupHook
  ];

  buildInputs = [
    qtbase
  ];

  postPatch = ''
    searchHardCodedPaths  # for debugging
    fixPath $out /usr/lib/systemd src/booster-dtkwidget/CMakeLists.txt
    fixPath $out /usr/lib/deepin-turbo src/booster-dtkwidget/deepin-turbo-booster-dtkwidget.service
  '';

  postFixup = ''
    searchHardCodedPaths $out  # for debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "A daemon that helps to launch applications faster";
    homepage = https://github.com/linuxdeepin/deepin-turbo;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
