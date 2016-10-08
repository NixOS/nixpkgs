{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qtermwidget";
  version = "0.7.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "18dnrzpbijh0xdgx83zs8nlbxk0d7hgzib54fqqvxyrjjy4g9scz";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase ];

  meta = with stdenv.lib; {
    description = "A terminal emulator widget for Qt 5";
    homepage = https://github.com/lxde/qtermwidget;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
