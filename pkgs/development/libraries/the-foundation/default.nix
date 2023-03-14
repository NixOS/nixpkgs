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

stdenv.mkDerivation (finalAttrs: {
  pname = "the-foundation";
  version = "1.6.0";

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = "the_Foundation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+V2WJYEmIZWpioNvvZMiw7Vt9ogEnEcjq+vR7UiBTO0=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ curl libunistring openssl pcre zlib ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/the_Foundation.pc \
      --replace '="''${prefix}//' '="/'
  '';

  meta = with lib; {
    description = "Opinionated C11 library for low-level functionality";
    homepage = "https://git.skyjake.fi/skyjake/the_Foundation";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
