{ stdenv, fetchFromGitHub, cmake
, qtbase }:

stdenv.mkDerivation rec {
  name = "libqmatrixclient-${version}";
  version = "0.4.2.1";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "libqmatrixclient";
    rev    = "v${version}";
    sha256 = "056hvp2m74wx72yd8vai18siddj9l8bhrvrkc4ia4cwjsqw02kid";
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
