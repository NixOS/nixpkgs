{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "138ppnwkqkfi7nnqpd0b93dqaph72ma65m9286bz2qzlis1x8r0v";
  };

  configureFlags = [ "--enable-all" ];

  outputs = [ "out" "dev" "doc" "lib" ];

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
     # fix recursive cycle:
     # wolfssl-config points to dev, dev propagates bin
     moveToOutput bin/wolfssl-config "$dev"
     # moveToOutput also removes "$out" so recreate it
     mkdir -p "$out"
  '';

  meta = with lib; {
    description = "A small, fast, portable implementation of TLS/SSL for embedded devices";
    homepage    = "https://www.wolfssl.com/";
    platforms   = platforms.all;
    license = lib.licenses.gpl2;
    maintainers = with maintainers; [ mcmtroffaes ];
  };
}
