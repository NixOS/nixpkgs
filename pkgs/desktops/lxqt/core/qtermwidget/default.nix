{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qtermwidget";
  version = "0.7.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0awp33cnkpi9brpx01mz5hwj7j2lq1wdi8cabk3wassd99vvxdxz";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase ];

  meta = with stdenv.lib; {
    description = "A terminal emulator widget for Qt 5";
    homepage = https://github.com/lxde/qtermwidget;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
