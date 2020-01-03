{ stdenv, mkDerivation, fetchFromGitHub, fetchpatch, pkgconfig, qmake, qtx11extras, dtkcore, deepin }:

mkDerivation rec {
  pname = "dtkwm";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0rdzzqsggqarldwb4yp5s4sf5czicgxbdmibjn0pw32129r2d1g3";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    dtkcore
    qtx11extras
  ];

  patches = [
    # Set DTK_MODULE_NAME
    (fetchpatch {
      url = "https://github.com/linuxdeepin/dtkwm/commit/2490891a.patch";
      sha256 = "0krydxjpnaihkgs1n49b6mcf3rd3lkispcnkb1j5vpfs9hp9f48j";
    })
  ];

  outRef = placeholder "out";

  qmakeFlags = [
    "QT_HOST_DATA=${outRef}"
    "INCLUDE_INSTALL_DIR=${outRef}/include"
    "LIB_INSTALL_DIR=${outRef}/lib"
  ];

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin graphical user interface library";
    homepage = https://github.com/linuxdeepin/dtkwm;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
