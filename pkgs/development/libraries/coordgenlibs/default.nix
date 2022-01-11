{ fetchFromGitHub
, lib
, stdenv
, boost
, zlib
, cmake
, maeparser
}:

stdenv.mkDerivation rec {
  pname = "coordgenlibs";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iy5VFp+50ldyoGJtPI1w3VfndIAGwBb1Xh6Qp18q/wU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib maeparser ];

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
}
