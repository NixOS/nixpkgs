{ stdenv, fetchFromGitHub, cmake
, qtbase }:

stdenv.mkDerivation rec {
  name = "libqmatrixclient-${version}";
  version = "0.3.0.2";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "libqmatrixclient";
    rev    = "v${version}";
    sha256 = "03pxmr4wa818fgqddkr2fkwz6pda538x3ic9yq7c40x98zqf55w5";
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
