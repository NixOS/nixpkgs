{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, polkit-qt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-admin";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1nsf8sbgmfanvcxw67drhz1wrizkcd0p87jwr1za5rcgd50bi2yy";
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
    polkit-qt
  ];

  patchPhase = ''
    sed "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" \
      -i lxqt-admin-user/CMakeLists.txt
  '';

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "LXQt system administration tool";
    homepage = https://github.com/lxqt/lxqt-admin;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
