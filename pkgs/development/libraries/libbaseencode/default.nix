{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libbaseencode";
  version = "1.0.12";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TKmM2BPzas9qbWI8n63lfR8OvsSj+BKC12NXpfe9aow=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library written in C for encoding and decoding data using base32 or base64 (RFC-4648)";
    homepage = "https://github.com/paolostivanin/libbaseencode";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexbakker ];
  };
}
