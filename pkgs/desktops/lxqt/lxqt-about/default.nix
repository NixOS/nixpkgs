{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg }:

stdenv.mkDerivation rec {
  pname = "lxqt-about";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "14b13v1r5ncz4ycg25ac9ppafiifc37qws8kcw078if72rp9n121";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtx11extras
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "\''${LXQT_TRANSLATIONS_DIR}" "''${out}/share/lxqt/translations"
  '';

  meta = with stdenv.lib; {
    description = "Dialogue window providing information about LXQt and the system it's running on";
    homepage = https://github.com/lxqt/lxqt-about;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
