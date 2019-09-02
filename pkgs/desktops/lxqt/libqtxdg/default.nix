{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, qtsvg, lxqt-build-tools }:

mkDerivation rec {
  pname = "libqtxdg";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0y3s0hva64m64j9lqgnja1li8zhlywqzv8xwjg8pyd2nr9h918db";
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
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
