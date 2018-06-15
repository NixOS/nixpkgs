{ stdenv, fetchFromGitHub, cmake
, qtbase }:

stdenv.mkDerivation rec {
  name = "libqmatrixclient-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner  = "QMatrixClient";
    repo   = "libqmatrixclient";
    rev    = "v${version}";
    sha256 = "0sv5hhdsffq7092n6hggfz9a78qn3jfmbvw2flmc4ippzz563akv";
  };

  buildInputs = [ qtbase ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description= "A Qt5 library to write cross-platfrom clients for Matrix";
    homepage = https://matrix.org/docs/projects/sdk/libqmatrixclient.html;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
