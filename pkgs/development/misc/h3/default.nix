{ stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "h3";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "h3";
    rev = "v${version}";
    sha256 = "0mlv3jk0j340l0bhr3brxm3hbdcfmyp86h7d85537c81cl64y7kg";
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
