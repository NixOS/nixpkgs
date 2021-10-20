{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libbaseencode";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f52yh052z8k90d1ag6nk01p1gf4i1zxp1daw8mashs8avqr2m7g";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library written in C for encoding and decoding data using base32 or base64 (RFC-4648)";
    homepage = "https://github.com/paolostivanin/libbaseencode";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexbakker ];
  };
}
