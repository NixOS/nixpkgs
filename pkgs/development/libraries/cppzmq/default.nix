{ lib, stdenv, fetchFromGitHub, cmake, zeromq }:

stdenv.mkDerivation rec {
  pname = "cppzmq";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "v${version}";
    sha256 = "sha256-hKMHJF/FXPeQjkEXLTN6zjKMaVGa3LdIebXya3NRSzU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zeromq ];

  cmakeFlags = [
    # Tests try to download googletest at compile time; there is no option
    # to use a system one and no simple way to download it beforehand.
    "-DCPPZMQ_BUILD_TESTS=OFF"
  ];

  meta = with lib; {
    homepage = "https://github.com/zeromq/cppzmq";
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
