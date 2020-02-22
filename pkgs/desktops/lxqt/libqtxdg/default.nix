{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, qtsvg, lxqt-build-tools }:

mkDerivation rec {
  pname = "libqtxdg";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "16jqnpc740a6phq7vcgy85hl7253yzyw4m5h71r0vijk79ir73b5";
  };

  nativeBuildInputs = [ cmake lxqt-build-tools ];

  buildInputs = [ qtbase qtsvg ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DQTXDGX_ICONENGINEPLUGIN_INSTALL_PATH=$out/$qtPluginPrefix"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DCMAKE_INSTALL_LIBDIR=lib"
    )
  '';

  meta = with lib; {
    description = "Qt implementation of freedesktop.org xdg specs";
    homepage = https://github.com/lxqt/libqtxdg;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
