{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qlipper";
  version = "2016-09-26";

  srcs = fetchFromGitHub {
    owner = "pvanek";
    repo = pname;
    rev = "48754f28fe1050df58f2d9f7cd2becc019e2f486";
    sha256 = "0s35c08rlfnhp6j1hx5f19034q84ac56cs90wcb3p4spavdnzy2k";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase qt5.qttools ];

  meta = with stdenv.lib; {
    description = "Cross-platform clipboard history applet";
    homepage = https://github.com/pvanek/qlipper;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
