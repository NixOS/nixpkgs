{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qps";
  version = "1.10.17";

  src = fetchFromGitHub {
    owner = "QtDesktop";
    repo = pname;
    rev = version;
    sha256 = "1d5r6w9wsxjdrzq2hllrj2n1d9azy6g05hg0w0s6pikrmn1yl0a3";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase qt5.qtx11extras qt5.qttools ];

  meta = with stdenv.lib; {
    description = "The Qt process manager";
    homepage = https://github.com/QtDesktop/qps;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
