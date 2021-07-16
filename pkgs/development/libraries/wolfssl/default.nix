{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "1w9gs9cq2yhj5s3diz3x1l15pgrc1pbm00jccizvcjyibmwyyf2h";
  };

  # almost same as Debian but for now using --enable-all --enable-reproducible-build instead of --enable-distro to ensure options.h gets installed
  configureFlags = [ "--enable-all" "--enable-reproducible-build" "--enable-pkcs11" "--enable-tls13" "--enable-base64encode" ];

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
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ mcmtroffaes ];
  };
}
