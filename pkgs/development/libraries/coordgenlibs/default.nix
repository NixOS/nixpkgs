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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "18s3y9v6x246hapxy0cy4srnll4qqzqfx003j551l5f27b2ng8fn";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib maeparser ];

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
}
