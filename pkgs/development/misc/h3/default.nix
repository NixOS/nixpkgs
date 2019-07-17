{ stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "h3";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "h3";
    rev = "v${version}";
    sha256 = "0d0730iwz290qcryj0ij1mnvmx89plcrg21czw5y4k63wlq8ppfg";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/uber/h3";
    description = "Hexagonal hierarchical geospatial indexing system";
    license = licenses.asl20;
    maintainers = [ maintainers.kalbasit ];
  };
}
