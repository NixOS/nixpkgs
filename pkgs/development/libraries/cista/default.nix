{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cista";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "felixguendling";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E2B+dNFk0ssKhT9dULNFzpa8auRQ9Q0czuUjX6hxWPw=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCISTA_INSTALL=ON" ];

  meta = with lib; {
    homepage = "https://cista.rocks";
    description = "A simple, high-performance, zero-copy C++ serialization & reflection library";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
