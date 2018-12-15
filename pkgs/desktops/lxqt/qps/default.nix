{ stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qps";
  version = "1.10.18";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1cq5z4w2n119z2bq0njn508g5582jljdx2n38cv5b3cf35k91a49";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qt5.qtbase qt5.qtx11extras qt5.qttools ];

  meta = with stdenv.lib; {
    description = "The Qt process manager";
    homepage = https://github.com/lxqt/qps;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
