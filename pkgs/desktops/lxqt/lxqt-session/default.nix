{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase, qttools, qtsvg, qtx11extras, kwindowsystem, liblxqt, libqtxdg, xorg, xdg-user-dirs }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-session";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0ngcrkmfpahii4yibsh03b8v8af93hhqm42kk1nnhczc8dg49mhs";
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
    homepage = https://github.com/lxqt/lxqt-session;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
