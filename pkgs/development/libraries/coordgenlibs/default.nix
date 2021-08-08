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
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uperQnJ1Q+s15pAlg/f4XR5VJI484ygZ0F6pMvcVDv8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib maeparser ];

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
}
