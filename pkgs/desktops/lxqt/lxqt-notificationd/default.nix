{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtbase, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, qtx11extras }:

stdenv.mkDerivation rec {
  pname = "lxqt-notificationd";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1nawcxy2qnrngcxvwjwmmh4fn7mhnfgy1g77rn90243jvy29wv5f";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  postPatch = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"

    for f in {config,src}/CMakeLists.txt; do
      substituteInPlace $f \
        --replace "\''${LXQT_TRANSLATIONS_DIR}" "''${out}/share/lxqt/translations"
    done
  '';

  buildInputs = [
    qtbase
    qttools
    qtsvg
    kwindowsystem
    liblxqt
    libqtxdg
    qtx11extras
  ];

  meta = with stdenv.lib; {
    description = "The LXQt notification daemon";
    homepage = https://github.com/lxqt/lxqt-notificationd;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
