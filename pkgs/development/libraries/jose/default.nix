{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, zlib, jansson, openssl
}:

stdenv.mkDerivation rec {
  pname = "jose";
  version = "10";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "15ac8a656m66rd9qg4dj53smykwaagqv606h18w7fiqn0ykxl4vi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zlib jansson openssl ];

  outputs = [ "out" "dev" "man" ];
  enableParallelBuilding = true;

  meta = {
    description = "C-language implementation of Javascript Object Signing and Encryption";
    homepage = "https://github.com/latchset/jose";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.asl20;
  };
}
