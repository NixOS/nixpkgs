{ stdenv, fetchFromGitHub, substituteAll, qmake, pkgconfig, qttools,
  dde-qt-dbus-factory, proxychains, which, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-network-utils";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0nj9lf455lf2hyqv6xwhm4vrr825ldbl83azzrrzqs6p781x65i1";
  };

  nativeBuildInputs = [
    qmake
    pkgconfig
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    proxychains
    which
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit which proxychains;
    })
  ];

  postPatch = ''
    searchHardCodedPaths  # for debugging
    patchShebangs translate_generation.sh
  '';

  postFixup = ''
    searchHardCodedPaths $out  # for debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin network utils";
    homepage = https://github.com/linuxdeepin/dde-network-utils;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
