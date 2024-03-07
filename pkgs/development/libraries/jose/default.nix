{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja, asciidoc
, zlib, jansson, openssl
}:

stdenv.mkDerivation rec {
  pname = "jose";
  version = "11";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TKcXswF50B8MS+XHSEvqHaFSAct7VdsnZ0RtZCF04Lc=";
  };

  nativeBuildInputs = [ meson pkg-config ninja asciidoc ];
  buildInputs = [ zlib jansson openssl ];

  outputs = [ "out" "dev" "man" ];
  enableParallelBuilding = true;

  meta = {
    description = "C-language implementation of Javascript Object Signing and Encryption";
    homepage = "https://github.com/latchset/jose";
    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.asl20;
  };
}
