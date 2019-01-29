{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qtermwidget";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "05gbdjzgmcr3ljs9ba3qvh7a3v6yn6vakwfy8avld9gy5bdd76rg";
  };

  nativeBuildInputs = [ cmake lxqt.lxqt-build-tools ];

  buildInputs = [ qt5.qtbase qt5.qttools];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A terminal emulator widget for Qt 5";
    homepage = https://github.com/lxqt/qtermwidget;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
