{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase, qttools, qtsvg, qtx11extras, kwindowsystem, liblxqt, libqtxdg, xorg, xdg-user-dirs }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-session";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "03gi9svxqsfjhk5ifbaalq9i44ggx8afwms1hb312czqn82wrszb";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtsvg
    qtx11extras
    kwindowsystem
    liblxqt
    libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
    xdg-user-dirs
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = ''
    for dir in autostart config; do
      substituteInPlace $dir/CMakeLists.txt \
        --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg"
    done
  '';

  meta = with stdenv.lib; {
    description = "An alternative session manager ported from the original razor-session";
    homepage = https://github.com/lxde/lxqt-session;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
