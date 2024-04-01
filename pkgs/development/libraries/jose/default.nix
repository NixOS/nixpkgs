{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja, asciidoc
, zlib, jansson, openssl
}:

stdenv.mkDerivation rec {
  pname = "jose";
  version = "12";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MuYRgYskIT2rmd32gziCdiRwIWMKQ6iTx0Qm/jJI+Iw=";
  };

  nativeBuildInputs = [ meson pkg-config ninja asciidoc ];
  buildInputs = [ zlib jansson openssl ];

  outputs = [ "out" "dev" "man" ];
  enableParallelBuilding = true;

  meta = {
    description = "C-language implementation of Javascript Object Signing and Encryption";
    mainProgram = "jose";
    homepage = "https://github.com/latchset/jose";
    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.asl20;
  };
}
