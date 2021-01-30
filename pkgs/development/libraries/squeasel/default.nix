{
  fetchFromGitHub,
  lib,
  stdenv,
  openssl,
  sqlite,
  wolfssl,
}:
stdenv.mkDerivation rec {
  pname = "squeasel";
  version = "d83cf6d9af0e2c98c16467a6a035ae0d7ca21cb1";

  src = fetchFromGitHub {
    owner = "cloudera";
    repo = "squeasel";
    rev = version;
    hash = "sha256:0b5vx5z2xl3whyrw5155w3z9lgm8ij992xcaghbwv2hjwhd0wwvb";
  };

  buildInputs = [
    openssl
    sqlite
    wolfssl
  ];

  buildPhase = ''
    make squeasel.o
    ar cr libsqueasel.a squeasel.o
  '';

  installPhase = ''
    mkdir -p $out/lib/
    mv libsqueasel.a $out/lib
  '';

  meta = {
    homepage = "https://github.com/cloudera/squeasel";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevincox ];
    description = "Easy to use, powerful, embeddable web server";
  };
}
