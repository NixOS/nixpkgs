{ stdenv, lib, fetchFromGitHub, cmake, check, validatePkgConfig, shared ? false }:

stdenv.mkDerivation rec {
  pname = "pugixml";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "pugixml";
    rev = "v${version}";
    sha256 = "sha256-Udjx84mhLPJ1bU5WYDo73PAeeufS+vBLXZP0YbBvqLE=";
  };

  outputs = if shared then [ "out" "dev" ] else [ "out" ];

  nativeBuildInputs = [ cmake validatePkgConfig ];

  cmakeFlags = [
    "-DBUILD_TESTS=ON"
    "-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"}"
  ];

  checkInputs = [ check ];

  preConfigure = ''
    # Enable long long support (required for filezilla)
    sed -ire '/PUGIXML_HAS_LONG_LONG/ s/^\/\///' src/pugiconfig.hpp
  '';

  meta = with lib; {
    description = "Light-weight, simple and fast XML parser for C++ with XPath support";
    homepage = "https://pugixml.org";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
