{ stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "h3";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "h3";
    rev = "v${version}";
    sha256 = "1ccyzbvbacf0bl9av4yp15zmhiqr3679nnbab11yrhxm9csyal16";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_LINTING=OFF"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/uber/h3";
    description = "Hexagonal hierarchical geospatial indexing system";
    license = licenses.asl20;
    maintainers = [ maintainers.kalbasit ];
  };
}
