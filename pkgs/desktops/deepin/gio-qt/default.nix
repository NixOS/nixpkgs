{ stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, glibmm
, qtbase
, deepin
}:

mkDerivation rec {
  pname = "gio-qt";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1v0bg0r0clfdlp10n6hb4kh7wyszama6mb8q91qhqd741bv0r4m9";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    deepin.setupHook
  ];

  propagatedBuildInputs = [
    glibmm
    qtbase
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging
  '';

  cmakeFlags = [
    "-DBUILD_DOCS=OFF"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Qt wrapper library of Gio";
    homepage = "https://github.com/linuxdeepin/gio-qt";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
