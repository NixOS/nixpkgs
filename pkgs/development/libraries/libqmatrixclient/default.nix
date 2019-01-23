{ stdenv, fetchFromGitHub, cmake
, qtbase }:

stdenv.mkDerivation rec {
  name = "libqmatrixclient-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "libqmatrixclient";
    rev    = "v${version}";
    sha256 = "16hi2xqlb4afspqw31c5w63qp0j4gkd6sl7j637b8cac2yigbbns";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description= "A Qt5 library to write cross-platfrom clients for Matrix";
    homepage = https://matrix.org/docs/projects/sdk/libqmatrixclient.html;
    license = licenses.lgpl21;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
