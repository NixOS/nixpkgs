{ stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "h3";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "h3";
    rev = "v${version}";
    sha256 = "1a4scs5n9srq6sjkz8d60ffzpc6aadkxmk1i3hdj081j0jzsrpf7";
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
