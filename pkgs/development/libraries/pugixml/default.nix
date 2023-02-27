{ stdenv, lib, fetchFromGitHub, cmake, check, validatePkgConfig, shared ? false }:

stdenv.mkDerivation rec {
  pname = "pugixml";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "pugixml";
    rev = "v${version}";
    sha256 = "sha256-MAXm/9ANj6TjO1Skpg20RYt88bf6w1uPwRwOHXiXsWw=";
  };

  outputs = [ "out" ] ++ lib.optionals shared [ "dev" ];

  nativeBuildInputs = [ cmake validatePkgConfig ];

  cmakeFlags = [
    "-DBUILD_TESTS=ON"
    "-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"}"
  ];

  nativeCheckInputs = [ check ];

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
