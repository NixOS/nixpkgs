{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qlipper";
  version = "5.0.0";

  srcs = fetchFromGitHub {
    owner = "pvanek";
    repo = pname;
    rev = version;
    sha256 = "1y34vadxxjg2l7021y1rpvb8x6pzhk2sk9p35wfm9inilwi8bg8j";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase qt5.qttools ];

  meta = with stdenv.lib; {
    description = "Cross-platform clipboard history applet";
    homepage = https://github.com/pvanek/qlipper;
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
