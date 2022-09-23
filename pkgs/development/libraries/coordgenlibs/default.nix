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
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u8UmJ4bu00t7qxiNZ3nL7cd+8AIC0LoICj5FNPboCTQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib maeparser ];

  meta = with lib; {
    description = "Schrodinger-developed 2D Coordinate Generation";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.bsd3;
  };
}
