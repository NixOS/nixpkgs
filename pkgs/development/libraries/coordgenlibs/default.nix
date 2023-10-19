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
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-casFPNbPv9mkKpzfBENW7INClypuCO1L7clLGBXvSvI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib maeparser ];

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
}
