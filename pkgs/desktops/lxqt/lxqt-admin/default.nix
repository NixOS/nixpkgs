{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtx11extras, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, polkit-qt }:

stdenv.mkDerivation rec {
  pname = "lxqt-admin";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0sdb514hgha5yvmbzi6nm1yx1rmbkh5fam09ybidjwpdwl2l4pxx";
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

  postPatch = ''
    sed "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" \
      -i lxqt-admin-user/CMakeLists.txt

    for f in lxqt-admin-{user,time}/CMakeLists.txt; do
      substituteInPlace $f \
        --replace "\''${LXQT_TRANSLATIONS_DIR}" "''${out}/share/lxqt/translations"
    done
  '';

  meta = with stdenv.lib; {
    description = "LXQt system administration tool";
    homepage = https://github.com/lxqt/lxqt-admin;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
