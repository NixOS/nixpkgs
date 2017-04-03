{
  stdenv, fetchFromGitHub, standardPatch,
  cmake, lxqt-build-tools,
  qtbase, qtx11extras, qttools, qtsvg, libdbusmenu, libqtxdg,
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-qtplugin";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "12hyw7rk3zx51n6g2bazlqv70xap0lygm9v21ibxgy1aw0j6iy02";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    qtsvg
    libdbusmenu
    libqtxdg
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  postPatch = standardPatch;

  meta = with stdenv.lib; {
    description = "LXQt Qt platform integration plugin";
    homepage = https://github.com/lxde/lxqt-qtplugin;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
