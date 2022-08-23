{ lib
, stdenv
, fetchFromGitea
, cmake
, pkg-config
, curl
, libunistring
, openssl
, pcre
, zlib
}:

stdenv.mkDerivation rec {
  pname = "the-foundation";
  version = "1.4.0";

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = "the_Foundation";
    rev = "v${version}";
    hash = "sha256-IHwWJryG4HcrW9Bf8KJrisCrbF86RBQj6Xl1HTmcr6k=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ curl libunistring openssl pcre zlib ];

  meta = with lib; {
    description = "Opinionated C11 library for low-level functionality";
    homepage = "https://git.skyjake.fi/skyjake/the_Foundation";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
