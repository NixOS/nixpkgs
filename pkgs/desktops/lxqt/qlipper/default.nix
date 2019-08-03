{ stdenv, fetchFromGitHub, cmake, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qlipper";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "pvanek";
    repo = pname;
    rev = version;
    sha256 = "0vlm4ab9isi7i2bimnyrk6083j2dfdrs14qj59vjcjri7mcwmf76";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase qttools ];

  meta = with stdenv.lib; {
    description = "Cross-platform clipboard history applet";
    homepage = https://github.com/pvanek/qlipper;
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
